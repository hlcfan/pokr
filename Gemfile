source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.2'

gem 'mysql2', '~> 0.4.4'

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
gem 'paperclip', '~> 5.1.0'
gem 'letter_avatar'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0', group: :doc

gem "react_on_rails", "~> 6"
gem 'puma'
gem 'redis-rails', '~> 5.0.2'
gem 'mina-puma', '1.0.1', require: false
gem 'multi_fetch_fragments'
gem 'sitemap_generator'
gem 'whenever', :require => false
gem 'mina-sitemap_generator', :require => false

# gem 'rack-mini-profiler'
# gem 'flamegraph'
# gem 'stackprof'     # For Ruby MRI 2.1+
# gem 'fast_stack'    # For Ruby MRI 2.0
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

group :development, :test do
  gem "pry"
  gem 'pry-doc'
  gem 'pry-nav'
  gem 'pry-rails'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :production do
  gem 'skylight'
  gem 'god'
end

group :test do
  gem 'rspec-rails', '~> 3.5'
  gem 'rails-controller-testing'
  gem 'codecov', :require => false
end