module Muse
  Commands = Pry::CommandSet.new do
    import Pry::Commands
    
    command "suite", "Sets the class or set of behaviors being tested" do |*words|
      unless words.empty?
        target.eval("self").clear_lines!
        target.eval("self").suite = words.join(" ")
      end
    end

    command "test", "Sets the specific test, action, or behavior being tested" do |*words|
      unless words.empty?
        target.eval("self").clear_lines!
        target.eval("self").test = words.join(" ")
      end
    end

    command "test-libs", "Sets or displays the test libraries used in this project" do |*libs|
      if libs.empty?
        output.puts target.eval("self").test_libraries
      else
        output.puts target.eval("self").test_libraries = libs.map {|lib| lib.to_sym}
      end
    end

    command "load-test-env", "Loads the test env by eval'ing the formatter's preamble" do
      test_dir = target.eval("self").format.test_dir
      preamble = target.eval("self").format.preamble
      # Add test dir to load path
      target.eval(%{$:.unshift(File.join(Dir.pwd, "#{test_dir}"))})
      # Eval the preamble that will be at the head of every test file
      target.eval(preamble)
    end

    command "setup", "Captures the following lines for the setup" do
      # TODO: allow an argument to be provided as a single line to eval
      # TODO: make it not run everytime
      run "load-test-env"
      SetupRepl.start(target)
    end

    command "assert", "Captures the current lines and results for building assertions" do
      # TODO: allow an argument to be provided as a single line to eval
      # TODO: make it not run everytime
      run "load-test-env"
      AssertionRepl.start(target)
    end

    command "show-test", "Shows the current test" do
      output.puts target.eval("self").format.test
    end
    
    command "edit-test", "Opens the subject test in the editor and pastes in the current context." do
      context = target.eval("self")
      formatter = context.format
      
      if formatter.suite_name && formatter.test_name
        # TODO: make it not run everytime
        run "load-test-env"

        if File.exists?(formatter.path)
          output.puts "Using test file at #{formatter.path}"
          target.eval(%{load "#{formatter.path}"})
          output.puts "Copying test to clipboard."
          Clipboard.copy(formatter.test(2))
          
          if Object.const_get(formatter.suite_name).respond_to?(formatter.test_name)
            run "edit-method", "#{formatter.suite_name}##{formatter.test_name}"
          else
            run "edit", "-r", formatter.path
          end
        else
          output.puts "Creating test file at #{formatter.path}"
          FileUtils.touch(formatter.path)
          
          output.puts "Copying suite to clipboard."
          Clipboard.copy(formatter.suite)
          
          run "edit", "-r", formatter.path
        end
      else
        ouput.puts "Unable to determine a suite and test name for your test setup."
      end
    end
  end
end