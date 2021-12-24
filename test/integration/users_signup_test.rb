require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid signup information' do
    get signup_path

    assert_no_difference -> { User.count } do
      post users_path, params: { user: { name: '',
                                         email: 'user@invalid',
                                         password: 'foo',
                                         password_confirmation: 'bar' } }
    end

    assert_response :success
    assert_equal users_path, path
    assert_select 'h1', 'Sign up'
    assert_select '.alert-danger', 'The form contains 4 errors'
    assert_select 'li', "Name can't be blank"
    assert_select 'li', 'Email is invalid'
    assert_select 'li', 'Password is too short (minimum is 6 characters)'
    assert_select 'li', "Password confirmation doesn't match Password"
  end

  test 'valid signup infromation' do
    get signup_path

    assert_difference -> { User.count }, 1 do
      post users_path, params: { user: { name: 'Example User',
                                         email: 'user@example.com',
                                         password: 'password',
                                         password_confirmation: 'password' } }
    end

    assert_redirected_to User.last
    assert_equal 'Welcome to the Sample App!', flash[:success]
    follow_redirect!
    assert_select 'h1', 'user@example.com'
  end
end
