module Muse
  module TestLibs
    module MiniTestSpec
      include MiniTest
      
      def suite_definition
        %{describe "#{@context.suite || "<feature>"}" do}
      end

      def test_definition(indent = 0)
        " " * indent + %{it "#{@context.test || "<description>"}" do}
      end
      
    end
  end
end