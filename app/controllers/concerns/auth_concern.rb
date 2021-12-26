module AuthConcern
  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete :user_id
    @current_user = Guest.new
    #session.clear
  end

  def logged_in?
    !current_user.guest?
  end
  
  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) || Guest.new
  end

  def authenticate_user!
    redirect_to login_path, status: :see_other unless logged_in?
  end
end
