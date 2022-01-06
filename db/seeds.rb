User.create name: 'Test User',
            email: 'u@test.gg',
            password: 'qwerty',
            password_confirmation: 'qwerty',
            admin: true,
            activated: true,
            activated_at: Time.zone.now

50.times do |n|
  name = Faker::Name.unique.name
  email = Faker::Internet.safe_email name: name
  password = 'password'
  password_confirmation = 'password'

  User.create!  name: name,
                email: email,
                password: password,
                password_confirmation: password_confirmation,
                activated: true,
                activated_at: Time.zone.now
end

users = User.order(:created_at).take(6)

50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { _1.microposts.create! content: content }
end

users = User.all
user = users.first
following = users[2..30]
followers = users[3..15]

following.each { user.follow _1 }
followers.each { _1.follow user }
