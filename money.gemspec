$:.push File.expand_path("../lib/spook_and_puff", __FILE__)

Gem::Specification.new do |s|
  s.name        = "spook_and_puff_money"
  s.version     = "1.0.2"
  s.authors     = ["Ben Hull"]
  s.email       = ["gems@companionstudio.com.au"]
  s.homepage    = "https://github.com/companionstudio/money"
  s.summary     = "A simple money class."

  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "README.md"]

  s.add_development_dependency "rspec",     "2.13.0"
  s.add_development_dependency "yard",      "0.9.20"
  s.add_development_dependency "redcarpet", "2.2.2"
end
