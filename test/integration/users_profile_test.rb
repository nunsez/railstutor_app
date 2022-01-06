require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :two
  end

  test 'profile display' do
    get user_path @user

    assert_response :success
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1 > img.gravatar'
    assert_select '.microposts > nav > .pagination'

    assert_select '.microposts > h3' do |node|
      assert_match @user.microposts.count.to_s, node.text
    end

    @user.microposts.page(1).each do |micropost|
      assert_select '.micropost .content', micropost.content
    end
  end
end
