require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'valid routing' do
    assert_routing login_path, controller: 'sessions', action: 'new'
    assert_routing({ path: login_path, method: :post }, controller: 'sessions', action: 'create')
    assert_routing({ path: logout_path, method: :delete }, controller: 'sessions', action: 'destroy')
  end
end
