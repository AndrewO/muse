require 'stringio'

module Muse
  class TestFile
    attr_reader :context
    def initialize(context)
      @context = context
      
      @context.test_libraries.each do |lib|
        self.extend Muse::TestLibs[lib]
      end
    end

    # Suite naming and retrieval
    def suite_name
      raise
    end

    def suite_class
      raise
    end

    def test_name
      raise
    end

    def test_method
      raise
    end

    def test_location
      test_method.source_location if test_method
    end

    # Path management
    def test_dir
      raise
    end

    def file_name
      raise
    end

    def path
      File.join(Dir.pwd, test_dir, file_name)
    end

    # Suite formatting
    def suite
      preamble +
      suite_definition + "\n" +
        test(2) +
      "end" + "\n"
    end

    def preamble
      raise
    end

    # Test formatting
    def test(indent = 0)
      test_definition(indent) + "\n" +
        lines(indent + 2) + "\n" +
      " " * (indent) + "end" + "\n"
    end

    def suite_definition
      raise
    end

    def test_definition(indent = 0)
      raise
    end

    def lines(indent = 0)
      @context.lines.map do |line| 
        " " * indent + case line
        when InputLine
          input_line(line)
        when AssertionLine
          assertion_line(line)
        end
      end.join("\n")
    end

    def input_line(line)
      line.line.strip
    end

    def assertion_line(line)
      raise
    end
  end
end