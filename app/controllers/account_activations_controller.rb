class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]

    case
    when !user
      flash[:warning] = 'User not found.'
      redirect_to root_path, status: :unprocessable_entity

    when user.activated?
      flash[:info] = 'Account already active!'
      redirect_to user, status: :see_other

    when user.authenticated?(:activation, params[:id])
      if user.activate
        log_in user
        flash[:success] = 'Account activated!'
        redirect_to user, status: :see_other
      else
        flash[:warning] = 'Invalid activation link.'
        redirect_to root_path, status: :unprocessable_entity
      end

    else
      flash[:warning] = 'Something went wrong, try again later.'
      redirect_to root_path, status: :unprocessable_entity
    end
  end
end
