User.create name: 'Test User',
            email: 'u@test.gg',
            password: 'qwerty',
            password_confirmation: 'qwerty'


99.times do |n|
  name = Faker::Name.unique.name
  email = Faker::Internet.safe_email name: name
  password = 'password'
  password_confirmation = 'password'

  User.create!  name: name,
                email: email,
                password: password,
                password_confirmation: password_confirmation
end
