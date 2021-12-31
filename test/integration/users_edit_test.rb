require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :one
  end

  test 'unseccessful edit' do
    log_in_as @user
    get edit_user_path(@user)

    assert_response :success

    patch user_path(@user), params: { user: { name: '',
                                              email: 'foo@invalid',
                                              password: 'foo',
                                              password_confirmation: 'bar' } }

    assert_response :unprocessable_entity
    assert_equal user_path(@user), path
  end

  test 'successful edit' do
    log_in_as @user
    get edit_user_path(@user)

    assert_response :success

    new_name = 'Foo Bar'
    new_email = 'foo@bar.com'

    assert_no_changes -> { @user.password_digest } do
      patch user_path(@user), params: { user: { name: new_name,
                                                email: new_email,
                                                password: '',
                                                password_confirmation: '' } }

      @user.reload
    end

    refute flash.empty?
    assert_response :see_other
    assert_redirected_to @user
    assert_equal new_name, @user.name
    assert_equal new_email, @user.email
  end
end
