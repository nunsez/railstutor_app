source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

gem 'rails', github: 'rails/rails', branch: '7-0-stable'
gem 'puma', '~> 5.0'

gem 'bcrypt'
gem 'carrierwave'
gem 'importmap-rails'
gem 'kaminari'
gem 'mini_magick' # dependencies: sudo apt install -y imagemagick
gem 'sass-rails'
gem 'slim-rails'
gem 'sprockets-rails'
gem 'turbo-rails'

group :production do
  gem 'pg'
end

group :development, :test do
  gem 'debug', platforms: %i[ mri mingw x64_mingw ]
  gem 'faker'
  gem 'minitest-reporters'
  gem 'rexml'
  gem 'sqlite3', '~> 1.4' # dependencies: sudo apt install -y libsqlite3-dev
end

group :development do
  # gem 'listen'
  # gem 'spring'
  gem 'web-console'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[ mingw mswin x64_mingw jruby ]
