require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # setup do
  #   ActionMailer::Base.deliveries.clear
  # end

  test 'invalid signup information' do
    get signup_path

    assert_no_difference -> { User.count } do
      post users_path,  params: { user: { name: '',
                                          email: 'user@invalid',
                                          password: 'foo',
                                          password_confirmation: 'bar' } }
    end

    assert_response :unprocessable_entity
    assert_equal users_path, path
    assert_select 'h1', 'Sign up'
    assert_select '.alert-danger', 'The form contains 4 errors'
    assert_select 'li', "Name can't be blank"
    assert_select 'li', 'Email is invalid'
    assert_select 'li', 'Password is too short (minimum is 6 characters)'
    assert_select 'li', "Password confirmation doesn't match Password"
  end

  test 'valid signup infromation with account activation' do
    get signup_path

    assert_difference -> { User.count } => 1,
                      -> { ActionMailer::Base.deliveries.size } => 1 do
      post users_path,  params: { user: { name: 'Example User',
                                          email: 'user@example.com',
                                          password: DEFAULT_PASSWORD,
                                          password_confirmation: DEFAULT_PASSWORD } }
    end

    fresh_user = User.last
    fresh_mail = ActionMailer::Base.deliveries.last
    matched = fresh_mail.body.encoded.match /account_activations\/(.*)\/edit/
    remember_token = matched[1]

    refute_predicate fresh_user, :activated?

    log_in_as fresh_user
    refute logged_in?
    assert flash[:warning]

    assert_no_changes -> { fresh_user.activated? } do
      get edit_account_activation_path('invalid token')
      fresh_user.reload
    end

    refute logged_in?
    assert flash[:warning]

    assert_no_changes -> { fresh_user.activated? } do
      get edit_account_activation_path(remember_token, email: 'wrong@email.bad')
      fresh_user.reload
    end

    refute logged_in?
    assert flash[:warning]

    assert_changes -> { fresh_user.activated? } do
      get edit_account_activation_path(remember_token, email: fresh_user.email)
      fresh_user.reload
    end

    assert_redirected_to fresh_user
    assert logged_in?
    assert flash[:success]
  end
end
