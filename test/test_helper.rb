$:.unshift(File.dirname(__FILE__) + "/lib")
require "muse"

require "rubygems"
require "bundler"
Bundler.require(:default, :test)

require "minitest/spec"
require "wrong/adapters/minitest"

# Muse loads the this file when the test env is loaded, but we don't realy want to autorun.
require "minitest/autorun" unless $MUSE_SAYS_NOT_TO_AUTORUN

class MiniTest::Spec
  include Wrong
end