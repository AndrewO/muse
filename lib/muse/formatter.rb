require 'stringio'

module Muse
  class Formatter
    attr_reader :context, :output
    def initialize(context)
      @context = context
    end
  end
end