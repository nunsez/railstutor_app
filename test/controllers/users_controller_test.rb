require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :one
    @other_user = users :two
  end

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

  test 'should redirect edit when not logged in' do
    get edit_user_path(@user)

    assert_redirected_to login_path
  end

  test 'should redirect update when not logged in' do
    assert_no_changes -> { @user } do
      patch user_path(@user), params: { user: { name: 'Foo Bar',
                                                email: 'foo@bar.com' } }

      @user.reload
    end

    assert_redirected_to login_path
  end

  test 'should redirect edit when logged in as wrong user' do
    log_in_as @other_user
    get edit_user_path(@user)

    assert_redirected_to root_path
  end

  test 'should redirect update when logged in as wrong user' do
    log_in_as @other_user

    assert_no_changes -> { @user } do
      patch user_path(@user), params: { user: { name: 'Foo Bar',
                                                email: 'foo@bar.com' } }

      @user.reload
    end

    assert_redirected_to root_path
  end
end
