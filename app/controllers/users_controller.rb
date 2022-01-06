class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[index edit update destroy following followers]
  before_action :correct_user, only: %i[edit update]
  before_action :admin_user, only: :destroy

  def index
    page = params[:page]
    @users = User.active.page(page)
  end

  def new
    redirect_to current_user, status: :found unless current_user.guest?
    @user = User.new
  end

  def create
    @user = User.new users_params

    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check your email too activate your account.'
      redirect_to root_path, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find_by_id params[:id]

    unless @user&.activated?
      redirect_to root_path, status: :see_other
      return
    end

    page = params[:page]
    @microposts = @user.microposts.page(page)
  end

  def edit
    @user = User.find_by_id params[:id]
  end

  def update
    @user = User.find_by_id params[:id]

    if @user.update users_params
      flash[:success] = 'Profile updated!'
      redirect_to @user, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find_by_id params[:id]

    if user.admin?
      flash[:danger] = "You can't delete admin user."
    else
      user.destroy
      flash[:success] = 'User deleted.'
    end

    redirect_to users_path
  end

  def following
    @title = 'Following'
    @user = User.find_by_id params[:id]
    @users = @user.following.page params[:page]
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @user = User.find_by_id params[:id]
    @users = @user.followers.page params[:page]
    render 'show_follow'
  end

  private

  def users_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
