# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "muse/version"

Gem::Specification.new do |s|
  s.name        = "muse"
  s.version     = Muse::VERSION
  s.authors     = ["Andrew O'Brien"]
  s.email       = ["obrien.andrew@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "muse"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  
  s.add_runtime_dependency "pry"
  # Pry uses this, but so to we.
  s.add_runtime_dependency "slop"
  s.add_runtime_dependency "clipboard"
  s.add_runtime_dependency "activesupport"
  s.add_runtime_dependency "i18n"
  
  # Should probably think about extracting test libs into plugins
  # MiniTest::Spec.children was added in 2.1, which is after the version distributed with Ruby 1.9
  s.add_runtime_dependency "minitest", ">= 2.1.0"
end
