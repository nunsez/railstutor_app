module AuthConcern
  def id = :user_id

  def log_in(user)
    session[id] = user.id
  end

  def log_out
    session.delete id
    @current_user = nil
    #session.clear
  end

  def logged_in? = !current_user.guest?
  
  def current_user
    @current_user ||= User.find_by_id(session[id]) || Guest.new
  end

  def authenticate_user!
    redirect_to login_path, status: :see_other unless logged_in?
  end
end
