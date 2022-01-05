class Guest
  def id = nil
  
  def guest? = true
  
  def admin? = false

  def email = nil

  def created_at = nil

  def microposts = []

  def ==(obj)
    obj.is_a? self.class
  end
end
