Gem::Specification.new do |s|
  s.name        = 'refract'
  s.version     = '0.0.0'
  s.date        = '2017-04-30'
  s.summary     = "Refract"
  s.description = "Crawler that auto generates SitePrism Page Objects"
  s.authors     = ["Nate Reynolds"]
  s.email       = 'nate@n8r.us'
  s.files       =  Dir['lib/**/*.rb']
  s.homepage    = 'https://github.com/nvreynolds/refract'

  s.add_dependency("spidr", "~> 0.6.0")

  s.add_development_dependency("pry", "~> 0.10.4")
end
