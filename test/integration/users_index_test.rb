require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users :one
    @user = users :two
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
    get users_path(2)

    assert_response :success
    assert_select '.users > *', count: 5

    User.page(2).per(5).each do |user|
      assert_select 'a[href=?]', user_path(user), user.name
    end
  end

  test 'delete users as admin' do
    log_in_as @admin
    get users_path

    admin_users_count = User.page(1).per(5).filter(&:admin?).count
    assert_select '.users .delete-user', count: 5 - admin_users_count

    assert_difference -> { User.count }, -1 do
      delete user_path(@user)
    end

    assert_no_difference -> { User.count } do
      delete user_path(@admin)
    end
  end

  test 'index as non-admin' do
    log_in_as @user
    get users_path

    assert_select '.users .delete-user', false
  end
end
