# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name          = 'exchequer'
  s.version       = '0.1.0'
  s.authors       = ['Pat Allan']
  s.email         = ['pat@freelancing-gods.com']
  s.homepage      = 'https://github.com/pat/exchequer'
  s.summary       = 'Chargify Workflow Toolbox'
  s.description   = 'An Object-Oriented approach to working with Chargify in Ruby'

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ['lib']

  s.add_runtime_dependency 'chargify_api_ares', '> 0'
  s.add_runtime_dependency 'activemodel',       '> 0'

  s.add_development_dependency 'rspec', '>= 2.11.0'
end
