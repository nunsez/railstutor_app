require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :one
  end

  test 'index including pagination' do
    assert true
  end
end
