class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]

    case
    when !user
      flash[:danger] = 'User not found.'
      redirect_to root_path, status: :unprocessable_entity

    when user.activated?
      flash[:info] = 'Account already active!'
      redirect_to user, status: :see_other

    when user.authenticated?(:activation, params[:id])
      if user.update activated: true, activated_at: Time.zone.now
        log_in user
        flash[:success] = 'Account activated!'
        redirect_to user, status: :see_other
      else
        flash[:danger] = 'Invalid activation link.'
        redirect_to root_path, status: :unprocessable_entity
      end

    else
      flash[:danger] = 'Something went wrong, try again later.'
      redirect_to root_path, status: :unprocessable_entity
    end
  end
end
