ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/reporters'

Minitest::Reporters.use!(
  Minitest::Reporters::DefaultReporter.new,
  ENV,
  Minitest.backtrace_filter
)

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include ApplicationHelper
  DEFAULT_PASSWORD = 'password'

  def log_in_as(user, **kwargs)
    password = kwargs[:password] || DEFAULT_PASSWORD
    remember_me = kwargs[:remember_me] || '1'


    if integration_test?
      
      post login_path, params: { session: { email: user.email,
                                            password: password,
                                            remember_me: remember_me } }
    else
      log_in user
    end
  end

  def integration_test?
    defined? follow_redirect!
  end
end
