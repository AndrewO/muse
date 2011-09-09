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
        "#{@context.suite.underscore}_test.rb"
      end
      
      def test
        preamble +
        
        suite_definition + "\n" +
          test_definition(2) + "\n" +
            lines(4) + "\n" +
          " " * 2 + "end" + "\n" +
        "end" + "\n"
      end
      
      def preamble
        %{require 'test_helper'\n}
      end
      
      def suite_definition
        %{class Test#{@context.suite || "<Name>"} < MiniTest::Test::TestCase}
      end
      
      def test_definition(indent = 0)
        " " * indent + %{test_#{@context.test || "<name>"}}
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