$:.push File.expand_path("../lib/spook_and_puff", __FILE__)

Gem::Specification.new do |s|
  s.name        = "spook_and_puff_money"
  s.version     = "0.5.6"
  s.authors     = ["Luke Sutton", "Ben Hull"]
  s.email       = ["lukeandben@spookandpuff.com"]
  s.homepage    = "http://spookandpuff.com"
  s.summary     = "A simple money class."

  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "README.md"]

  s.add_development_dependency "rspec",     "2.13.0"
  s.add_development_dependency "yard",      "0.8.6.1"
  s.add_development_dependency "redcarpet", "2.2.2"
end
