module Muse
  module Prompt
    def prompt_proc
      proc {|muse_context, _| "#{suite_prompt(muse_context)}:#{test_prompt(muse_context)}#{mode_string} :) " }
    end
    
    def mode_string
      ""
    end
    
    def suite_prompt(muse_context)
      (muse_context.suite || '(suite)') + status_symbol(muse_context.suite_status)
    end

    def test_prompt(muse_context)
      (muse_context.test || '(test)') + status_symbol(muse_context.test_status)
    end

    def status_symbol(status)
      case status
      when :new
        "+"
      when :changed
        "*"
      else
        ""
      end
    end
  end
  
  class Repl < Pry
    include Prompt

    def self.start
      super(Muse::Context.new)
    end

    attr_reader :muse_context

    def initialize(options={})
      super({
        :commands => Pry::CommandSet.new do
          command "suite", "Sets the class or set of behaviors being tested" do |*words|
            target.eval("self").suite = words.join(" ") unless words.empty?
          end

          command "test", "Sets the specific test, action, or behavior being tested" do |*words|
            target.eval("self").test = words.join(" ") unless words.empty?
          end

          command "test-libs", "Sets or displays the test libraries used in this project" do |*libs|
            if libs.empty?
              output.puts target.eval("self").test_libraries
            else
              output.puts target.eval("self").test_libraries = libs.map {|lib| lib.to_sym}
            end
          end

          command "setup", "Captures the following lines for the setup" do
            SetupRepl.start(target)
          end

          command "assert", "Captures the current lines and results for building assertions" do
            AssertionRepl.start(target)
          end

          command "show-test", "Shows the current test" do
            output.puts target.eval("self").format.test
          end
          
          command "edit-test", "Opens the subject test in the editor and pastes in the current context." do

          end
        end,
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
      target_self.add_input_line(code)
      
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
      target_self.add_assertion(code)
      
      code
    end
    
    def re(target)
      result = super
      
      target = Pry.binding_for(target)
      target_self = target.eval("self")
      
      target_self.add_result(result)

      result
    end
  end
end