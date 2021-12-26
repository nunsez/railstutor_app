class UsersController < ApplicationController
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

  private

  def users_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
