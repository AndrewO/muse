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
end