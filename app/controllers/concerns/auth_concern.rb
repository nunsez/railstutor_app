module AuthConcern
  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end

  def log_out
    return unless logged_in?

    forget current_user
    session.delete :user_id
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

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def authenticate_user!
    return if logged_in?

    # flash[:danger] = 'Please log in.'
    store_location
    redirect_to login_path, status: :see_other
  end

  def correct_user
    redirect_to root_path, status: :see_other unless current_user?(params[:id])
  end

  def current_user?(value)
    case value
    when String
      value == current_user.id.to_s
    when Integer
      value == current_user.id
    else
      value.is_a?(ApplicationRecord) ? value == current_user : false
    end
  end

  def redirect_back_or(default, **kwargs)
    url = session[:forwarding_url] || default

    session.delete :forwarding_url
    redirect_to url, **kwargs
  end

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
end
