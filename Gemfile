# frozen_string_literal: true

source "https://rubygems.org"

gem "debug", platform: :mri
gem "rbs", "~> 2.0"
gem "rspec"
gem "pry"
gem 'sorbet'
gem 'sorbet-runtime'
gem 'tapioca', require: false

gemspec

eval_gemfile "gemfiles/rubocop.gemfile"

local_gemfile = "#{File.dirname(__FILE__)}/Gemfile.local"

if File.exist?(local_gemfile)
  eval(File.read(local_gemfile)) # rubocop:disable Security/Eval
end
