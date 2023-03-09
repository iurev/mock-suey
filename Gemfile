# frozen_string_literal: true

source "https://rubygems.org"

gem "debug", platform: :mri
gem "rbs"
gem "rspec"
# gem 'sorbet', require: false
# gem 'sorbet-runtime', require: false
# gem 'tapioca', require: false
gem 'pry'


# gem 'sorbet', :group => :development, path: "/home/yu/projects/sorbet/gems/sorbet"
gem 'sorbet', :group => :development
# gem 'sorbet-runtime', path: "/home/yu/projects/sorbet/gems/sorbet-runtime"
gem "sorbet-runtime"
gem 'tapioca', require: false, :group => :development

gemspec

eval_gemfile "gemfiles/rubocop.gemfile"

local_gemfile = "#{File.dirname(__FILE__)}/Gemfile.local"

if File.exist?(local_gemfile)
  eval(File.read(local_gemfile)) # rubocop:disable Security/Eval
end
