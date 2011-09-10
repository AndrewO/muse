module Muse
  module TestLibs
    module MiniTestSpec
      include MiniTest
      
      def self.in_use?
        Object.const_defined?(:MiniTest) && MiniTest.const_defined?(:Spec)
      end
      
      # Suite naming and retrieval
      def suite_class
        ::MiniTest::Spec.children.find {|child| child.desc.to_s == suite_name }
      end

      def suite_name
        @context.suite
      end

      def test_name
        "test_#{@context.test.underscore.gsub(" ", "_")}" if @context.test
      end

      def test_method
        suite_class.test_methods.find {|method| method =~ /^test_\d+_#{test_name}$/}
      end

      # Suite formatting
      def suite_definition
        %{describe #{suite_name.kind_of?(String) ? "#{suite_name}" : suite_name || "<Feature>"} do}
      end

      def test_definition(indent = 0)
        " " * indent + %{it "#{(test_name || "<feature>")}" do}
      end

      def test_name
        @context.test
      end
      
    end
  end
end