source 'http://rubygems.org'
gem "dispatcher"
gem "thin"
#gem "rest-client"
#gem 'mongrel', '>= 1.2.0.pre2'
gem 'daemons' , '1.0.10'
gem 'rails', '3.0.3'
gem 'mysql'
gem 'rake', '0.9.2'
# Integrations:
gem 'aws-s3'
gem 'zencoder'
gem 'paypal_adaptive', :git => 'https://github.com/jhonyf/paypal_adaptive.git',
                       :ref => '47ac0f73359f3bb1b7fa'

gem "grit"
gem "paperclip", "~> 2.3"
gem 'delayed_job'
gem 'delayed_job_admin'
gem 'activemerchant'

gem 'devise' , '1.3.4'

gem 'mime-types'


gem "capistrano"


# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

group :development, :test do
end
group :test do
  gem 'metric_fu'
  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem "rspec-rails", ">= 2.6.0"
  gem 'rspec-core' , '>= 2.6'
  gem "factory_girl"
  gem 'shoulda-matchers'
  gem 'ZenTest'
  gem 'test_notifier'
end

