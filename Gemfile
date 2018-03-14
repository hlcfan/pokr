source 'https://rubygems.org'

gem 'rails', '5.1.4'

gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2.1'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'mini_racer', platforms: :ruby

gem 'marked-rails'
gem 'font-awesome-rails'
gem 'awesome_nested_fields', git: 'https://github.com/hlcfan/awesome_nested_fields.git'
gem 'devise'
gem 'ruby-pinyin'
gem 'paperclip', '~> 5.2.1'
gem 'letter_avatar'

gem 'omniauth'
gem 'omniauth-weibo-oauth2'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-github'
gem 'omniauth-google-oauth2'
gem 'redis'
gem 'logster'
gem 'http_accept_language'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0', group: :doc

gem "react_on_rails", "~> 10"
gem "webpacker"
gem 'puma'
gem 'redis-rails', '~> 5.0.2'
gem 'sidekiq'
gem 'mina-puma', '1.0.1', require: false
gem 'sitemap_generator'
gem 'whenever', :require => false
gem 'mina-sitemap_generator', :require => false
gem 'mina-sidekiq', :require => false
gem 'rqrcode'
gem 'pg_search'

# Disable for error:
# Rack app error handling request { POST /mini-profiler-resources/results }
# #<Errno::ETIMEDOUT: Operation timed out - user specified timeout>
# gem 'rack-mini-profiler'
# gem 'flamegraph'
# gem 'stackprof'     # For Ruby MRI 2.1+

# gem 'fast_stack'    # For Ruby MRI 2.0
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

group :development, :test do
  gem 'rspec-rails', '~> 3.6'
  gem "pry"
  gem 'pry-doc'
  gem 'pry-nav'
  gem 'pry-rails'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'letter_opener'
end

group :production do
  gem 'skylight'
  gem 'god'
end

group :test do
  gem 'rails-controller-testing'
  gem 'codecov', :require => false
end
