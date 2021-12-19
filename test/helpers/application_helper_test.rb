require 'test_helper'

class ApplicationHelperTest < ActionDispatch::IntegrationTest
  test 'full title helper' do
    base_title = 'Railstutor App'

    assert_equal full_title, base_title
    assert_equal full_title('Help'), "Help | #{base_title}"
  end
end
