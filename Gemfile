source 'https://rubygems.org'
ruby '2.4.1'

gem 'rails', '5.1.1'
gem 'mysql2', '>= 0.3.18', '< 0.5'
gem 'bcrypt',                  '3.1.7'
gem 'faker',                   '1.4.2'
gem 'carrierwave'
gem 'mini_magick',             '3.8.0'
gem 'fog'
gem 'will_paginate'
gem 'bootstrap-will_paginate'
gem 'bootstrap-sass'
gem 'sass-rails'
gem 'uglifier',                '2.5.3'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'jbuilder'
gem 'sdoc',                    '0.4.0', group: :doc
gem 'figaro'
gem 'pkg-config'
gem 'nokogiri', '~> 1.8.2'
gem 'unicorn-worker-killer'
gem 'aws-sdk', '~> 2'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'web-console'
  gem 'spring'
  gem 'pry'
  gem 'rspec'
  gem 'rspec-rails'
end

group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest',     '2.3.1'
end

group :production do
  gem 'rails_12factor', '0.0.2'
end

group :staging, :production do
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano-sidekiq'
  gem 'capistrano3-unicorn'
  gem 'capistrano-faster-assets'
  gem 'unicorn'
end
