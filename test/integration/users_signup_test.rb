require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid signup information' do
    get signup_path

    assert_no_difference -> { User.count } do
      post users_path, params: { user: { name: '',
                                         email: 'user@invalid',
                                         password: 'foo',
                                         password_confirmation: 'bar' }}
    end

    assert_equal 200, status
    assert_equal users_path, path 
    assert_select 'h1', text: 'Sign up'
  end
end
