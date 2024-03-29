source "https://rubygems.org"
git_source(:github) {|repo| "https://github.com/#{repo}.git" }

ruby "2.7.5"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "rails", "~> 6.1.4"
# Use mysql as the database for Active Record
gem "mysql2", "~> 0.5"
# Use Puma as the app server
# gem "puma", "~> 5.0"
gem "unicorn"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.4", require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

gem "action_args"
gem "aws-sdk-rails", require: false
gem "aws-xray", require: ["aws/xray/rails", "aws/xray/hooks/net_http"]
# gem "aws-xray-sdk", require: false
# xray sdk ojじゃないと動かないとのこと
gem "dalli-elasticache"
gem "oj"
gem "rack-health"
gem "ridgepole"
gem "ulid"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "awesome_print"
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "listen", "~> 3.3"
  gem "pry-byebug"
  gem "pry-power_assert"
  gem "pry-rails"
  gem "pry-stack_explorer"

  gem "database_rewinder"
  gem "factory_bot_rails"
  gem "faker"
  gem "onkcop", require: false
  gem "rspec_junit_formatter"
  gem "rspec-power_assert"
  gem "rspec-rails"
  gem "rubocop-rails"
  gem "rubocop-select"
end

group :test do
  gem "simplecov", require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
