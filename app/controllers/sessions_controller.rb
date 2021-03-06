class SessionsController < ApplicationController
  def new
    redirect_to root_path, status: :found unless current_user.guest?

    @login_form = LoginForm.new
  end

  def create
    @login_form = LoginForm.new(sessions_params)

    if @login_form.valid?
      user = @login_form.user

      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user, status: :see_other
      else
        flash[:warning] = 'Account not activated. Check your email for the activation link.'
        redirect_to root_path, status: :see_other
      end

    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_path, status: :see_other
  end

  private

  def sessions_params
    params.require(:session).permit(:email, :password)
  end
end
