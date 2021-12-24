require 'test_helper'
require 'rexml'

class ApplicationHelperTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::AssetTagHelper
  include UsersHelper

  def get_img_src(img)
    doc = REXML::Document.new img
    src = doc.root['src']
    URI.parse src
  end

  setup do
    @user = User.new email: 'user@example.com'
    @id = Digest::MD5::hexdigest @user.email.downcase
  end

  test 'gravatar builder should work without kwargs' do
    img = gravatar_for @user
    uri = get_img_src(img)

    assert_equal "/avatar/#{@id}", uri.path
  end

  test 'gravatar builder should work with kwargs' do
    img = gravatar_for @user, size: 42
    uri = get_img_src(img)

    assert_equal "/avatar/#{@id}", uri.path
    assert_equal 'size=42', uri.query
  end
end
