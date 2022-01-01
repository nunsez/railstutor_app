module ApplicationHelper
  include AuthConcern

  def full_title(page_title = '')
    base_title = 'Railstutor App'

    return base_title if page_title.empty?
    return "#{page_title} | #{base_title}".html_safe
  end
end
