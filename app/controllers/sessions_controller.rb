class SessionsController < ApplicationController
  def new
    @login_form = LoginForm.new
  end

  def create
    @login_form = LoginForm.new(sessions_params)

    if @login_form.valid?
      flash[:success] = "Welcome back, #{@login_form.user.email}"

      redirect_to user_path(@login_form.user)
    else
      render :new
    end
  end

  def destroy
  end

  private

  def sessions_params
    params.require(:session).permit(:email, :password)
  end
end
