module Muse
  module TestLibs
    module MiniTest
      def self.in_use?
        Object.const_defined?(:MiniTest) && !MiniTest.const_defined?(:Spec)
      end
      
      # Suite naming and retrieval
      def suite_name
        "Test#{@context.suite.camelize}" if @context.suite
      end

      def suite_class
        suite_name.constantize
      end

      def test_name
        "test_#{@context.test.underscore.gsub(" ", "_")}" if @context.test
      end

      def test_method
        klass.instance_method(test_name) if klass = suite_class
      end

      # Path management
      def test_dir
        "test"
      end

      def file_name
        "test_#{@context.suite.gsub("::", "_").underscore.gsub(" ", "_")}.rb"
      end

      # Suite formatting
      def preamble
        %{require 'test_helper'\n\n}
      end

      # Test formatting
      def suite_definition
        %{class #{suite_name || "Test<Name>"} < MiniTest::Unit::TestCase}
      end

      def test_definition(indent = 0)
        " " * indent + "def #{(test_name || "test_<name>")}"
      end

      def assertion_line(line)
        %{assert_equal(#{line.result}, #{line.line.strip})}
      end
    end
  end
end