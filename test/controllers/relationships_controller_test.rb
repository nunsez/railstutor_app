require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :four
    @other_user = users :two
    #log_in_as @user
  end

  test 'create should require logged-in user' do
    assert_no_difference -> { Relationship.count } do
      post relationships_path
    end

    assert_redirected_to login_path
  end

  test 'destroy should require logged-in user' do
    assert_no_difference -> { Relationship.count } do
      post relationships_path(relationships :one)
    end

    assert_redirected_to login_path
  end

  test 'should follow a user' do
    log_in_as @user

    assert_difference -> { @user.following.count }, 1 do
      post relationships_path, params: { followed_id: @other_user.id }
      @user.reload
    end
  end

  test 'should unfollow a user' do
    log_in_as @user

    @user.follow @other_user
    relationship = @user.active_relationships.find_by(followed_id: @other_user.id)

    assert_difference -> { @user.following.count }, -1 do
      delete relationship_path(relationship)
      @user.reload
    end
  end
end
