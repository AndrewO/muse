module Muse
  module TestLibs
    module MiniTest
      def path
        if @out.kind_of?(File)
          @out.path
        else
          File.join(Dir.pwd, test_dir, file_path)
        end
      end
      
      def test_dir
        "test"
      end
      
      def file_path
        "test_#{@context.suite.underscore.gsub(" ", "_")}.rb"
      end
      
      def suite
        preamble +
        "\n" +
        suite_definition + "\n" +
          test(2) +
        "end" + "\n"
        
      end
      
      def test(indent = 0)
        test_definition(indent) + "\n" +
          lines(indent + 2) + "\n" +
        " " * (indent) + "end" + "\n"
      end
      
      def preamble
        %{require 'test_helper'\n}
      end
      
      def suite_definition
        %{class #{suite_name || "Test<Name>"} < MiniTest::Unit::TestCase}
      end
      
      def suite_name
        "Test#{@context.suite.camelize}" if @context.suite
      end
      
      def test_definition(indent = 0)
        " " * indent + "def #{(test_name || "test_<name>")}"
      end
      
      def test_name
        "test_#{@context.test.underscore.gsub(" ", "_")}" if @context.test
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
        %{assert_equal(#{line.result}, #{line.line.strip})}
      end
    end
  end
end