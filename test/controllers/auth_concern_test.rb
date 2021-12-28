require 'test_helper'

class AuthConcernTest < ActionView::TestCase
  setup do
    @user = users :one
    remember @user
  end

  test 'current user returns right user when session is nil' do
    assert_equal @user, current_user
    assert logged_in?
  end

  test 'current user returns guest when remember digest is wrong' do
    @user.update_attribute :remember_digest, User.digest(User.new_token)
    assert_equal Guest.new, current_user
  end

  test 'remember token from the model match the token in cookies' do
    remember @user
    assert_equal @user.remember_token, cookies[:remember_token]
  end
end
