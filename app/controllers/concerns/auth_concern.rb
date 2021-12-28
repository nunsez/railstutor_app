module AuthConcern
  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def log_out
    session.delete :user_id
    cookies.delete :user_id
    cookies.delete :remember_token
    @current_user = Guest.new
    #session.clear
  end

  def logged_in?
    !current_user.guest?
  end
  
  def current_user
    if user_id = session[:user_id]
      return @current_user ||= User.find_by_id(user_id) || Guest.new
    end

    if user_id = cookies.signed[:user_id]
      user = User.find_by_id(user_id)

      if user&.authenticated? cookies[:remember_token]
        log_in user
        return @current_user = user
      end
    end

    Guest.new
  end

  def authenticate_user!
    redirect_to login_path, status: :see_other unless logged_in?
  end
end
