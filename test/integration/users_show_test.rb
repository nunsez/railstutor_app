require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  test 'redirect show if user not activated' do
    inactive_user = users :three
    get user_path(inactive_user)
    assert_redirected_to root_path
  end
end
