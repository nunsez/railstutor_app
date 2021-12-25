require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  test 'login with invalid information' do
    get login_path

    assert_response :success

    post login_path, params: { session: { email: '',
                                          password: '' } }
    assert_response :success
    assert_select 'p', "can't be blank", count: 2
  end
end
