require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.new  name: 'Example User',
                      email: 'user@example.com',
                      password: DEFAULT_PASSWORD,
                      password_confirmation: DEFAULT_PASSWORD
  end

  test 'should be valid' do
    assert_predicate @user, :valid?
  end

  test 'name should be present' do
    @user.name = ' '

    refute_predicate @user, :valid?
  end

  test 'email should be present' do
    @user.email = ' '

    refute_predicate @user, :valid?
  end

  test 'name should not be too long' do
    @user.name = 'a' * 51

    refute_predicate @user, :valid?
  end

  test 'email should not be too long' do
    @user.email = "#{'a' * 244}@example.com"

    refute_predicate @user, :valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[
      user@example.com
      USER@foo.COM
      A_US-ER@foo.bar.org
      first.last@foo.jp
      alice+bob@baz.ru
    ]

    valid_addresses.each do |address|
      @user.email = address

      assert_predicate @user, :valid?
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[
      user@example,com
      user_at_foo.org
      user.name@example.
      user.name@example..com
      foo@bar_baz.com
      foo@bar+baz.com
      user@invalid
    ]

    invalid_addresses.each do |address|
      @user.email = address

      refute_predicate @user, :valid?
    end
  end

  test 'email addresses should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save

    refute_predicate duplicate_user, :valid?
  end

  test 'email addresses should be saved as lower case' do
    mixed_case_email = 'fOo@ExaMplE.cOm'
    @user.email = mixed_case_email
    @user.save

    assert_equal @user.reload.email, mixed_case_email.downcase
  end

  test 'password should have a minimum length' do
    invalid_password = 'a' * 5
    @user.password = invalid_password
    @user.password_confirmation = invalid_password

    refute_predicate @user, :valid?
  end

  test 'authenticated? should return false for a user with nil remember_digest' do
    refute @user.authenticated? :remember, nil
  end

  test 'associated microposts should be destroyed' do
    @user.save
    @user.microposts.create content: 'Lorem ipsum'

    assert_difference -> { Micropost.count }, -1 do
      @user.destroy
    end
  end
end
