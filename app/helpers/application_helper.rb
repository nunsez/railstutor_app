module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'Railstutor App'

    return base_title if page_title.empty?
    return sanitize "#{page_title} | #{base_title}"
  end
end
