# frozen_string_literal: true

source "https://rubygems.org"

gem "debug", platform: :mri
gem "rbs", "~> 2.0"
gem "rspec"
gem "pry", require: false
gem 'sorbet', require: false
gem 'sorbet-runtime', require: false, path: "/home/yu/projects/sorbet/gems/sorbet-runtime"
gem 'tapioca', require: false

gemspec

eval_gemfile "gemfiles/rubocop.gemfile"

local_gemfile = "#{File.dirname(__FILE__)}/Gemfile.local"

if File.exist?(local_gemfile)
  eval(File.read(local_gemfile)) # rubocop:disable Security/Eval
end
