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

    command "load-test-env", "Loads the test env by eval'ing the test_file's preamble" do
      target.eval("$MUSE_SAYS_NOT_TO_AUTORUN = true")
      context = target.eval("self")
      test_file = Muse::TestFile.new(context)

      test_dir = test_file.test_dir
      preamble = test_file.preamble

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
      context = target.eval("self")
      output.puts Muse::TestFile.new(context).test
    end
    
    command "edit-test", "Opens the subject test in the editor and pastes in the current context." do
      context = target.eval("self")
      test_file = Muse::TestFile.new(context)
      
      if test_file.suite_name && test_file.test_name
        # TODO: make it not run everytime
        run "load-test-env"

        if File.exists?(test_file.path)
          output.puts "Using test file at #{test_file.path}"
          target.eval(%{load "#{test_file.path}"})
          output.puts "Copying test to clipboard."
          Clipboard.copy(test_file.test(2))
          
          if test_file.suite_class && test_file.suite_class.respond_to?(test_file.test_name)
            run "edit-method", "#{test_file.suite_class.to_s}##{test_file.test_name}"
          else
            run "edit", "-r", test_file.path
          end
        else
          output.puts "Creating test file at #{test_file.path}"
          FileUtils.touch(test_file.path)
          
          output.puts "Copying suite to clipboard."
          Clipboard.copy(test_file.suite)
          
          run "edit", "-r", test_file.path
        end
      else
        ouput.puts "Unable to determine a suite and test name for your test setup."
      end
    end
  end
end