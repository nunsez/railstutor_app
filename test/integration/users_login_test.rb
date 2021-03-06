require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  class Rack::Test::CookieJar
    def signed = self
  end

  setup do
    @user = users :one
  end

  test 'login with invalid information' do
    get login_path

    assert_response :success

    post login_path, params: { session: { email: '',
                                          password: '' } }

    assert_response :unprocessable_entity
    assert_select 'p', "can't be blank", count: 2
  end

  test 'login with valid information followed by logout' do
    get login_path

    assert_response :success

    post login_path, params: { session: { email: @user.email,
                                          password: DEFAULT_PASSWORD } }

    # Logint asserts
    assert logged_in?
    assert_equal @user, current_user
    assert_redirected_to @user
    follow_redirect!
    assert_response :success
    assert_select 'a[href=?]', login_path, false
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)

    # Logout asserts
    delete logout_path

    # Test SessionsController#destroy
    assert_nil session[:user_id]

    # FIXME Use method for apply logout changes for View.
    # I don't know why @current_user from View and @current_user from Controller different
    # And I don't know how to fix it and save same AuthConcern logic for both View and Controller
    # log_out # <-- no problem at this time, so a commented that method
    refute logged_in?
    assert_equal Guest.new, current_user

    assert_redirected_to root_path

    # imitate second browser logout
    delete logout_path

    follow_redirect!
    assert_response :success
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, false
    assert_select 'a[href=?]', user_path(@user), false
  end

  test 'login with remembering' do
    log_in_as(@user, remember_me: '1')

    assert cookies[:remember_token]
  end

  test 'login without remembering' do
    log_in_as(@user, remember_me: '0')

    refute cookies[:remember_token]
  end
end
