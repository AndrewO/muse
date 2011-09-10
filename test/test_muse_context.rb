require 'test_helper'

describe Muse::Context do
  it "has lines" do
    context = Muse::Context.new
    assert { context.lines == [] }
  end
  
  it "adds input lines" do
    context = Muse::Context.new
    context.add_input_line!("a = 1")
    assert { context.lines.length == 1 }
    assert { context.lines[0].line == "a = 1" }
  end
  
  it "adds assertion lines" do
    context = Muse::Context.new
    context.add_assertion!("1 + 1")
    assert { context.lines.last.line == "1 + 1" }
  end

  it "adds assertion results" do
    context = Muse::Context.new
    context.add_assertion!("1 + 1")
    context.add_result!(2)
    assert { context.lines.last.line == "1 + 1" }
    assert { context.lines.last.result == 2 }
  end
  
  it "clears lines" do
    context = Muse::Context.new
    context.add_input_line!("a = 1")
    context.add_assertion!("1 + 1")
    context.add_result!(2)
    
    context.clear_lines!
    assert { context.lines.empty? }
  end
end
