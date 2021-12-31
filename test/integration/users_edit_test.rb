require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test 'unseccessful edit' do
    get edit_user_path(@user)

    assert_response :success

    patch user_path(@user), params: { user: { name: '',
                                              email: 'foo@invalid',
                                              password: 'foo',
                                              password_confirmation: 'bar' } }

    assert_response :unprocessable_entity
    assert_equal user_path(@user), path
  end
end
