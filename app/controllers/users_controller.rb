class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  
  def index
    @users = User.order("id ASC").page(params[:page]).per(20)
    #@users = User.all.page(params[:page])
  end
    
  def mod
    @user = User.find(params[:id])
    if @user.moderator == 0
      @user.moderator = 1
    else
      @user.moderator = 0
    end 
    @user.save
    redirect_to users_path
  end
  
  def admindestroy
  	@user = User.find(params[:id])
  	@user.destroy
  	redirect_to users_path
  end
  
  def raid
    @user = User.find(params[:id])
    if @user.raidmember == 0
      @user.raidmember = 1
    else
      @user.raidmember = 0
    end 
    @user.save
    redirect_to users_path
  end
  
  def forumadmin
    @user = User.find(params[:id])
    if @user.forem_admin == false
      @user.forem_admin = true
    else
      @user.forem_admin = false
    end 
    @user.save
    redirect_to users_path
  end
  
  def show
  	@user = current_user
  end
end
