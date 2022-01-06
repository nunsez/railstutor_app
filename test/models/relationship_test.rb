require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  setup do
    @relationship = relationships :one
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
