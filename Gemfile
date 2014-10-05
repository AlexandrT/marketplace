source "https://rubygems.org"

# Declare your gem's dependencies in marketplace.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
gem 'byebug'
group :test, :development do
  gem 'rspec-rails'
  gem 'nyan-cat-formatter'
  gem 'factory_girl_rails'
end

group :test do
  gem 'mongoid-rspec', github: 'mongoid-rspec/mongoid-rspec', :branch => 'mongoid-4-0'
end

gem 'tzinfo-data', platforms: [:x64_mingw,:mingw, :mswin]