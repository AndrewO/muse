module Muse
  class Context
    attr_accessor :suite, :test, :test_libraries
    attr_reader :lines
    def initialize(options = {})
      @suite = options.delete(:suite)
      @test = options.delete(:test)
      @lines = []
      @test_libraries = guess_test_libraries
    end

    def suite_status
      nil
    end
    
    def test_status
      nil
    end
    
    def add_input_line!(input)
      @lines << InputLine.new(input.strip)
    end
    
    def add_assertion!(code)
      @lines << AssertionLine.new(code.strip, nil)
    end
    
    def add_result!(result)
      @lines.last.result = result
    end
    
    def clear_lines!
      @lines = []
    end
    
    def guess_test_libraries
      # TODO: inspect working directory to determine test library
      [:mini_test_spec, :wrong]
    end
  end

  class InputLine < Struct.new(:line)
  end
  
  class AssertionLine < Struct.new(:line, :result)
  end
end