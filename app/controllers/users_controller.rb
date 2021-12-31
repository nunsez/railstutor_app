class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update]

  def new
    redirect_to current_user, status: :found unless current_user.guest?
    @user = User.new
  end

  def create
    @user = User.new(users_params)

    if @user.save
      log_in @user
      flash[:success] = 'Welcome to the Sample App!'
      redirect_to @user, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find_by_id(params[:id])
  end

  def edit
    @user = User.find_by_id(params[:id])
  end

  def update
    @user = User.find_by_id(params[:id])

    if @user.update(users_params)
      flash[:success] = 'Profile updated!'
      redirect_to @user, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def users_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
