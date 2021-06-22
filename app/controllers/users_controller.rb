class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]


  def index
    @users = User.paginate(page: params[:page])
  end

  
  def show

    @user =User.find_by id: params[:id]
    return if @user 

    redirect_to root_path

  end


  def new

    @user=User.new

  end


  def create
    @user = User.new user_params 
    if @user.save
      
      #log in new users automatic
      Log_in user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user

    else
      render 'new'
    end
  end



  def edit
    @user = User.find(params[:id])
  end



  def update
    @user = User.find(params[:id])
    if @user.update user_params

      flash[:success] = "Profile updated"
      redirect_to @user

    else

      render 'edit'

    end
  end


  def destroy
    User.find(params[:id]).destroy
    flash[:success]="User deleted !"
    redirect_to users_url
  end




  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Before filters

    # Confirms a logged-in user.

    def logged_in_user

      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end

    end

    #confirm correct user
    def correct_user
      @user=User.find(params[:id])
      redirect_to root_path unless @user == current_user?(user)
    end


    #confirm admin
    def admin_user
      redirect_to root_ unless current_user.admin?
    end


end
