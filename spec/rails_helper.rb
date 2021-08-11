require "spec_helper"
ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../spec/dummy/config/environment.rb", __dir__)
ENV["RAILS_ROOT"] ||= File.dirname(__FILE__) + "../../../spec/dummy"

require "rspec/rails"
