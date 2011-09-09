module Muse
  module TestLibs
    module Wrong
      def assertion_line(line)
        %{assert { #{line.line.strip} == #{line.result} }}
      end
    end
  end
end