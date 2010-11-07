class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  before_filter :signed_in_user, :only => [:new, :create]
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def show
    @user = User.find(params[:id])
	@microposts = @user.microposts.paginate(:page => params[:page])
	@title = @user.name
  end

  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def create  
    @user = User.new(params[:user])
    if @user.save
	  sign_in @user
	  flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
	  @user.password = ''
	  @user.password_confirmation = ''
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    @title = "Edit user"
  end
  
  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end  
  
  def destroy
	#Remember that params are strings, so we need to convert the id int to a string :P
	if current_user.id.to_s == params[:id].to_s
      flash[:success] = "You can't delete yourself, sorry."
      redirect_to users_path
	else
	  #print (current_user.id.to_s == params[:id]).to_s + " : " + params[:id].to_s + " - " +current_user.id.to_s
	  User.find(params[:id]).destroy
	  #flash[:notice] = (current_user.id.to_s == params[:id]).to_s + " : " + params[:id].to_s + " - " +current_user.id.to_s
	  flash[:success] = "User destroyed."
      redirect_to users_path
	end
  end  
  
  private
  
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
  
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end  
  
    def signed_in_user
	  if signed_in?
	    flash[:notice] = "You're already a user, crazy person."
	    redirect_to(root_path)
	  end
	end
end
