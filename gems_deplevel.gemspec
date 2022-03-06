Gem::Specification.new do |s|
  s.name = 'gems_deplevel'
  s.version = '0.1.0'
  s.summary = 'Returns the dependency depth level for a gem\'s transitive dependencies'
  s.authors = ['James Robertson']
  s.files = Dir['lib/gems_deplevel.rb']
  s.add_runtime_dependency('gems', '~> 1.2', '>=1.2.0')
  s.add_runtime_dependency('dir-to-xml', '~> 1.2', '>=1.2.2')
  s.signing_key = '../privatekeys/gems_deplevel.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/gems_deplevel'
end
