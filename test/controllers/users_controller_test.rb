require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'valid routing' do
    assert_routing signup_path, controller: 'users', action: 'new'
    assert_routing({ path: users_path, method: :post }, controller: 'users', action: 'create')
    assert_routing user_path(42), controller: 'users', action: 'show', id: '42'
    assert_raises(NameError) { new_user_path }
  end

  test 'should get signup' do
    get signup_path

    assert_response :success
    assert_select 'title', full_title('Signup')
  end
end
