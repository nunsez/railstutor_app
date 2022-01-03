require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :one
  end

  test 'password resets' do
    get new_password_reset_path
    assert_response :success

    # invalid email
    post password_resets_path, params: { password_reset_form: { email: '' } }
    assert_response :unprocessable_entity

    # valid email
    assert_difference -> { ActionMailer::Base.deliveries.size }, 1 do
      post password_resets_path, params: { password_reset_form: { email: @user.email } }
    end
    
    refute_equal @user.reset_digest, @user.reload.reset_digest
    assert_redirected_to root_path

    mail = ActionMailer::Base.deliveries.last
    matched = mail.body.encoded.match /password_resets\/(.*)\/edit/
    reset_token = matched[1]

    # invalid email, valid token
    get edit_password_reset_path(reset_token, email: '')
    assert_redirected_to root_path
    
    # valid email, valid token, unactivated user profile
    @user.toggle! :activated
    get edit_password_reset_path(reset_token, email: @user.email)
    assert_redirected_to root_path
    @user.toggle! :activated

    # valid email, invalid token
    get edit_password_reset_path('wrong token', email: @user.email)
    assert_redirected_to root_path

    # valid email, valid token
    get edit_password_reset_path(reset_token, email: @user.email)
    assert_response :success
    assert_select 'input[name=email][type=hidden][value=?]', @user.email

    # passwords don't match
    patch password_reset_path reset_token,
      params: { email: @user.email,
                user: { password: 'foobar',
                        password_confirmation: 'barbaz' } }

    assert_response :unprocessable_entity
    assert_select 'p.text-danger'

    # empty password
    patch password_reset_path reset_token,
      params: { email: @user.email,
                user: { password: ' ',
                        password_confirmation: 'barbaz' } }

    assert_response :unprocessable_entity
    assert_select 'p.text-danger'

    # correct case
    patch password_reset_path reset_token,
      params: { email: @user.email,
                user: { password: 'foobar',
                        password_confirmation: 'foobar' } }

    assert logged_in?
    refute_predicate flash, :empty?
    assert_redirected_to @user
  end
end
