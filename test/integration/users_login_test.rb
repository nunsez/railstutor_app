require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alex)
  end

  test 'login with invalid information' do
    get login_path

    assert_response :success

    post login_path, params: { session: { email: '',
                                          password: '' } }

    assert_response :unprocessable_entity
    assert_select 'p', "can't be blank", count: 2
  end

  test 'login with valid information' do
    get login_path

    assert_response :success

    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }

    assert_redirected_to @user
    follow_redirect!
    assert_response :success
    assert logged_in?
    assert_equal @user, current_user
    assert_select 'a[href=?]', login_path, false
    assert_select 'form[action=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)
  end
end
