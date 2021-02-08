source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'rails', '>= 5.2.4.3'
gem 'bootstrap-sass', '>= 3.4.1'
gem 'puma', '~> 3.11'
gem 'carrierwave', '1.3.2'
gem 'mini_magick', '>= 4.9.4'
gem 'will_paginate'
gem 'bootstrap-will_paginate', '1.0.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'font-awesome-sass', '~> 5.4.1'
gem 'dotenv-rails'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails', '4.3.1'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bcrypt', '~> 3.1.7'

gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  gem 'sqlite3', '1.3.13'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rubocop-airbnb'
  gem 'rspec-rails', '~> 3.6.0'
  gem 'factory_bot_rails', '~> 4.10.0'
  gem 'faker', '1.7.3'
  gem 'database_cleaner'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'webdrivers'
  gem 'launchy', '~> 2.4.3'
end

group :production do
  gem 'pg',  '0.20.0'
  gem 'fog', '1.42'
end

group :production, :staging do
  gem 'unicorn'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
