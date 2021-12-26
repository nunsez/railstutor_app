module UsersHelper
  def gravatar_for(user, **kwargs)
    id = Digest::MD5::hexdigest user.email.downcase
    size = kwargs[:size].to_i

    hash = {}
    hash[:size] = size if size.positive?

    uri = URI::HTTPS.build host: 'secure.gravatar.com',
                           path: "/avatar/#{id}",
                           query: hash.to_query

    image_tag uri.to_s, alt: user.name, class: 'gravatar'
  end
end
