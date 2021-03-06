class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable
  has_many :articles
  has_many :wowchars, dependent: :destroy
  has_many :comments

  def self.logins_before_captcha
    3
  end
  
  def admin
    self.thredded_admin==true
  end
    
  def forem_name
    username
  end
  
  def forem_email
    email
  end
  
  def to_s
    username
  end
  
  def can_read_forem_forums?
    persisted? && raidmember==1 
  end
  
  def thredded_can_read_messageboards
    if raidmember==1
      Thredded::Messageboard.all
    else
      Thredded::Messageboard.none
    end     
  end
  
  def thredded_can_moderate_messageboards
    Thredded::Messageboard.none
  end
end
