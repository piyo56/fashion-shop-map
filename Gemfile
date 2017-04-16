source 'https://rubygems.org'
ruby '2.3.1'
gem 'rails', '4.2.7.1'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'hirb'       # モデルの出力結果を表形式で表示するGem
gem 'hirb-unicode'

# Added for deploying
gem 'pg'
gem "gmaps4rails"
gem "geocoder"
gem 'hirb'
gem 'hirb-unicode'
gem 'bootstrap-sass'
gem 'gretel' # パンくずリスト

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
