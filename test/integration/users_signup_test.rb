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
    assert_select 'h1', text: 'Sign up'
  end

  test 'valid signup infromation' do
    get signup_path

    assert_difference -> { User.count }, 1 do
      post users_path, params: { user: { name: 'Example User',
                                         email: 'user@example.com',
                                         password: 'password',
                                         password_confirmation: 'password' } }
    end

    assert_redirected_to controller: 'users', action: 'show', id: 1
  end
end
