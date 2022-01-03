class PasswordResetsController < ApplicationController
  before_action :get_user, only: %i[edit update]
  before_action :valid_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]

  def new
    @password_reset_form = PasswordResetForm.new
  end

  def create
    @password_reset_form = PasswordResetForm.new password_reset_params

    if @password_reset_form.valid?
      user = @password_reset_form.user

      user.create_reset_digest
      user.send_password_reset_email
      flash[:info] = 'Email sent with password reset instructions.'
      redirect_to root_path, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if password_blank?
      render :edit, status: :unprocessable_entity
    elsif @user.update user_params
      log_in @user
      flash[:success] = 'Password has been reset.'
      redirect_to @user, status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def password_reset_params
    params.require(:password_reset_form).permit(:email)
  end

  def password_blank?
    if params[:user][:password].blank?
      @user.errors.add(:password, "can't be blank.")
      return true
    end
  end

  def get_user
    @user = User.find_by email: params[:email]
    @token = params[:token]
  end

  def valid_user
    unless @user&.activated? && @user.authenticated?(:reset, @token)
      redirect_to root_path, status: :see_other
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = 'Password reset token has expired.'
      redirect_to new_password_reset_path
    end
  end
end
