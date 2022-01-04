require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  setup do
    @user = users :two
    @micropost = @user.microposts.build content: 'Lorem ipsum'
  end

  test 'should be valid' do
    assert_predicate @micropost, :valid?
  end

  test 'user id should be present' do
    @micropost.user_id = nil
    refute_predicate @micropost, :valid?
  end

  test 'content should be present' do
    @micropost.content = ' '
    refute_predicate @micropost, :valid?
  end

  test 'content should be at most 140 characters' do
    @micropost.content = 'a' * 141
    refute_predicate @micropost, :valid?
  end

  test 'order should be most recent first' do
    assert_equal Micropost.first, microposts(:two)
  end
end
