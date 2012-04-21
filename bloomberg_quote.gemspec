# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bloomberg_quote/version"

Gem::Specification.new do |s|
  s.name        = "bloomberg_quote"
  s.version     = BloombergQuote::VERSION
  s.authors     = ["MATSUI Shinsuke"]
  s.email       = ["poppen.jp@gmail.com"]
  s.homepage    = "https://github.com:poppen/bloomberg_quote.git"
  s.summary     = "getting quotes form Bloomberg site"
  s.description = "BloombergQuote is a module which getting quotes form Bloomberg site"

  s.rubyforge_project = "bloomberg_quote"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "fakeweb"
  s.add_runtime_dependency "nokogiri"

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
