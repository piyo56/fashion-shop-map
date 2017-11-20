source 'https://rubygems.org'
ruby '2.3.1'
gem 'rails', '4.2.7.1'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

# Added for deploying
gem 'mysql2'
gem 'pg'
gem "gmaps4rails"
gem "geocoder"
gem 'hirb'
gem 'hirb-unicode'
gem 'bootstrap-sass'
gem 'gretel' # パンくずリスト

# use unicorn as app server
gem 'unicorn'

group :development, :test do
  gem 'byebug'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-doc'    # methodを表示
  
  gem 'capybara'
  gem 'capybara-email'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'poltergeist'
  gem 'rspec-rails'
  gem 'shoulda-matchers'

  # deployment with capistrano3
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv'
  gem 'capistrano3-unicorn'
end

group :development do
  gem 'web-console', '~> 2.0'

  gem "better_errors"
  gem "binding_of_caller"
  gem 'spring'
  gem 'annotate'   # modelのソースの先頭にテーブルのスキーマ情報を付加してくれる
end

group :production do
  gem 'rails_12factor'
end
