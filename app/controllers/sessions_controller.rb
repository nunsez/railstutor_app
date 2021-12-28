class SessionsController < ApplicationController
  def new
    redirect_to root_path, status: :found unless current_user.guest?

    @login_form = LoginForm.new
  end

  def create
    @login_form = LoginForm.new(sessions_params)

    if @login_form.valid?
      user = @login_form.user
      log_in user
      remember user

      redirect_to user, status: :see_other
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
