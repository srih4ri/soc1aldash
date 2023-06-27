source 'https://rubygems.org'

gem 'rails', '3.2.9'
gem 'thin'
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'bootstrap-sass'
  gem 'sass-rails',   '~> 6.0.0'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

gem 'devise' # User authentication
gem 'omniauth' # Auth to social apps
gem 'omniauth-twitter' # Twitter provider
gem 'twitter' # Interact with twitter API
gem 'omniauth-facebook' # Facebook provider
gem 'fb_graph' # Interact with facebook graph API

group :development do
  gem "factory_girl_rails"
end

gem "rspec-rails", :group => [:test, :development]
group :test do
  gem "capybara"
  gem "guard-rspec"
  gem 'guard-spork'
  gem 'rb-inotify', '~> 0.8.8'
  gem 'shoulda-matchers'
  gem 'timecop'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
