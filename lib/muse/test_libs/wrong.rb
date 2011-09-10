module Muse
  module TestLibs
    module Wrong
      def self.in_use?
        Object.const_defined?(:Wrong)
      end
      
      def assertion_line(line)
        %{assert { #{line.line.strip} == #{line.result} }}
      end
    end
  end
end