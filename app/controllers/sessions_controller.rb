class SessionsController < ApplicationController
  def new
    @login_form = LoginForm.new
  end

  def create
    @login_form = LoginForm.new(sessions_params)

    if @login_form.valid?
      log_in @login_form.user
      flash[:success] = "Welcome back, #{@login_form.user.email}"

      redirect_to @login_form.user, status: :see_other
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
