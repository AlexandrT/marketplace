include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"
rbenv_ruby "2.1.4"

rbenv_gem "bundler" do
	ruby_version "2.1.4"
end