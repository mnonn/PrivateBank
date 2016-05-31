require 'set'

class ForemToThredded < ActiveRecord::Migration
  def up
    skip_callbacks = [
        [Thredded::Post, :create, :after, :update_parent_last_user_and_timestamp],
        [Thredded::PrivatePost, :create, :after, :update_parent_last_user_and_timestamp],
        [Thredded::Post, :commit, :after, :notify_at_users],
        [Thredded::PrivatePost, :commit, :after, :notify_at_users],
    ]
    begin
      # Disable all timestamp handling
      ActiveRecord::Base.record_timestamps = false
      # Rails 4.1 has .no_touching, but 4.0 does not
      original_touch = ActiveRecord::Base.instance_method(:touch)
      ActiveRecord::Base.send(:define_method, :touch) { |*| }
      # Disable callbacks to avoid creating notifications and performing unnecessary updates
      skip_callbacks.each { |(klass, *args)| klass.skip_callback(*args) }

      forem_data = %i(
        categories forums groups memberships moderator_groups 
        posts subscriptions topics views
      ).inject({}) { |h, k|
        h.update k => connection.select_all("SELECT * FROM forem_#{k}")
      }
      transaction do
        now = Time.zone.now
        say 'Copying Messageboards...'
        boards = forem_data[:forums].inject({}) { |h, f|
          h.update(
              f['id'] => Thredded::Messageboard.create!(
                  name:        f['name'],
                  description: f['description'],
                  slug:        f['slug'],
                  created_at:  now,
                  updated_at:  now
              )
          )
        }
        say "Created #{boards.size} Messageboards"
        say 'Copying Topics...'
        forem_posts_by_topic = forem_data[:posts].group_by { |p| p['topic_id'] }
        topics = forem_data[:topics].reject { |t| t['state'] == 'spam' }.inject({}) { |h, t|
          last_post = forem_posts_by_topic[t['id']].max_by { |p| p['created_at'] }
          h.update(
              t['id'] => Thredded::Topic.create!(
                  messageboard_id: boards[t['forum_id']].id,
                  user_id:         t['user_id'],
                  title:           t['subject'],
                  slug:            t['slug'],
                  sticky:          t['pinned'],
                  locked:          t['locked'],
                  created_at:      t['created_at'],
                  updated_at:      last_post['created_at'],
                  last_user_id:    last_post['user_id']
              )
          )
        }
        say "Created #{topics.size} Topics"
        say 'Copying Posts...'
        posts = forem_data[:posts].reject { |t| t['state'] == 'spam' }.inject({}) { |h, p|
          topic = topics[p['topic_id']]
          h.update(
              p['id'] => Thredded::Post.create!(
                  user_id:         p['user_id'],
                  messageboard_id: topic.messageboard_id,
                  postable_id:     topic.id,
                  created_at:      p['created_at'],
                  updated_at:      p['updated_at'],
                  content:         p['text']
              )
          )
        }
        say "Created #{posts.size} Posts"

        say 'Creating UserDetails'
        rename_column Thredded.user_class.table_name, :forem_admin, :thredded_admin
        posts.values.group_by(&:user_id).each do |user_id, user_posts|
          user_detail = Thredded::UserDetail.create!(
              user_id:            user_id,
              latest_activity_at: user_posts.max_by(&:created_at).created_at,
              created_at:         now,
              updated_at:         now)
          Thredded::UserDetail.reset_counters(user_detail.id, :topics, :posts)
        end

        say 'Updating counters'
        boards.each { |_k, v| Thredded::Messageboard.reset_counters(v.id, :topics, :posts) }
        topics.each { |_k, v| Thredded::Topic.reset_counters(v.id, :posts) }
      end
    ensure
      # Re-enable timestamp handling
      ActiveRecord::Base.record_timestamps = true
      ActiveRecord::Base.send(:define_method, :touch, original_touch)
      # Re-enable callbacks
      skip_callbacks.each { |(klass, *args)| klass.set_callback(*args) }
    end
  end

  def down
    rename_column Thredded.user_class.table_name, :thredded_admin, :forem_admin
    [Thredded::Messageboard, Thredded::Topic, Thredded::Post, Thredded::UserDetail].each(&:delete_all)
  end
end