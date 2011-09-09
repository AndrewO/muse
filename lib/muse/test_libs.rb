require "muse/test_libs/mini_test"
require "muse/test_libs/mini_test_spec"
require "muse/test_libs/wrong"

module Muse
  module TestLibs
    @all = {
      :mini_test => Muse::TestLibs::MiniTest,
      :mini_test_spec => Muse::TestLibs::MiniTestSpec,
      :wrong => Muse::TestLibs::Wrong
    }
    
    def self.[](key)
      @all[key]
    end
  end
end