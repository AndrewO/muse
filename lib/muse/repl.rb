require 'fileutils'

module Muse
  class Repl < Pry
    include Prompt

    def self.start(options = {})
      Pry.config.history.file = File.join(Dir.pwd, ".muse_history")
      Pry.config.history.should_save = true
      Pry.config.history.should_load = true
      # Not sure why I have to call load_history.
      Pry.load_history

      super(Muse::Context.new(options.to_hash))
    end

    attr_reader :muse_context

    def initialize(options={})
      super({
        :commands => Muse::Commands,
        :prompt => prompt_proc
      }.merge(options))
    end

  end
  
  class SetupRepl < Pry
    include Prompt

    def initialize(options = {})
      super({
        :prompt => prompt_proc
      }.merge(options))
    end

    def mode_string
      " *setup*"
    end

    def r(target)
      code = super
      
      target = Pry.binding_for(target)
      target_self = target.eval("self")
      target_self.add_input_line!(code)
      
      code
    end
  end
  
  class AssertionRepl < Pry
    include Prompt

    def initialize(options = {})
      super({
        :prompt => prompt_proc
      }.merge(options))
    end

    def mode_string
      " *assert*"
    end
    
    def r(target)
      code = super
      
      target = Pry.binding_for(target)
      target_self = target.eval("self")
      target_self.add_assertion!(code)
      
      code
    end
    
    def re(target)
      result = super
      
      target = Pry.binding_for(target)
      target_self = target.eval("self")
      
      target_self.add_result!(result)

      result
    end
  end
end