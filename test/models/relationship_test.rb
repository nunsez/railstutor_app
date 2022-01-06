require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  setup do
    @user_one = users :one
    @user_two = users :two
    # @relationship = relationships :one
    @relationship = Relationship.create follower_id: @user_two.id, followed_id: @user_one.id
  end

  test 'should be valid' do
    assert_predicate @relationship, :valid?
  end

  test 'should require a follower_id' do
    @relationship.follower_id = nil
    refute_predicate @relationship, :valid?
  end

  test 'should require a followed_id' do
    @relationship.followed_id = nil
    refute_predicate @relationship, :valid?
  end
end
