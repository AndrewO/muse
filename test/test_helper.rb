$:.unshift(File.dirname(__FILE__) + "/lib")
require "muse"

require "rubygems"
require "bundler"
Bundler.require(:default, :test)

require "minitest/spec"
require "wrong/adapters/minitest"

require "minitest/autorun"

class MiniTest::Spec
  include Wrong
end