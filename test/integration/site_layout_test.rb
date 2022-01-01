require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :two
  end

  test 'layout links for guest' do
    get root_path

    assert_select 'a[href=?]', root_path
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', users_path, count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
    assert_select 'a[href=?]', edit_user_path(@user), count: 0
    assert_select 'form[action=?]', logout_path, count: 0
  end

  test 'layout links for user' do
    log_in_as @user
    get root_path

    assert_select 'a[href=?]', root_path
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', users_path
    assert_select 'a[href=?]', user_path(@user)
    assert_select 'a[href=?]', edit_user_path(@user)
    assert_select 'form[action=?]', logout_path
  end
end
