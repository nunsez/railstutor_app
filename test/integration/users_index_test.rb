require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :one
  end

  test 'index including pagination' do
    log_in_as @user
    get users_path

    assert_response :success
    assert_select 'nav ul.pagination'

    # Test first page
    assert_select '.users > *', count: 5

    User.page(1).per(5).each do |user|
      assert_select 'a[href=?]', user_path(user), user.name
    end

    # Test second page
    get users_path 2

    assert_response :success
    assert_select '.users > *', count: 5

    User.page(2).per(5).each do |user|
      assert_select 'a[href=?]', user_path(user), user.name
    end
  end
end
