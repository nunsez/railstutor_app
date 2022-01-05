require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :two
  end

  test 'micropost interface' do
    log_in_as @user
    get root_path

    # invalid micropost content
    assert_no_difference -> { Micropost.count } do
      post microposts_path, params: { micropost: { content: '' } }
    end

    assert_select '.field_with_errors > #micropost_content'

    # valid micropost content
    content = 'foo bar baz'
    assert_difference -> { @user.microposts.count }, 1 do
      post microposts_path, params: { micropost: { content: content } }
    end

    assert_redirected_to root_path
    follow_redirect!
    assert_select '.micropost .content', content

    # delete micropost
    recent_micropost = @user.microposts.last

    assert_difference -> { @user.microposts.count }, -1 do
      delete micropost_path(recent_micropost)
    end

    # get another user profile
    get user_path(users :one)
    assert_select '.delete-micropost', false
  end

  test 'micropost sidebar count' do
    log_in_as @user
    get root_path

    assert_select '.user-card div', text: '52 microposts'

    other_user = users(:four)
    log_in_as other_user

    get root_path
    assert_select '.user-card div', text: '0 microposts'

    other_user.microposts.create content: 'Lorem ipsum'

    get root_path
    assert_select '.user-card div', text: '1 micropost'
  end
end
