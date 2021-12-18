module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'Railstutor App'

    return base_title if page_title.empty?
    return "#{page_title} | #{base_title}".html_safe
  end

  def nav_classes(nav = nil)
    base_classes = 'nav-link'

    nav == params[:action] ? "#{base_classes} active" : base_classes
  end
end
