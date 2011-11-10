Gem::Specification.new do |s|
  s.name            = "javert"
  s.homepage        = "http://www.lsiowa.org"
  s.email           = "carl.limyao@lsiowa.org"
  s.date            = Time.now
  s.summary         = "Ldap mapper-ish thinger for Ruby"
  s.description     = "A library to help you build models that hook to ldap"
  s.authors         = ["Carl Limyao"]
  s.require_path    = 'lib'
  s.version         = '0.0.2'
  s.platform        = Gem::Platform::RUBY
  s.files           = Dir.glob("{lib}/**/*")
  
  s.add_dependency 'activemodel', '~> 3.0'
  s.add_dependency 'activesupport', '~> 3.0'
  s.add_dependency 'net-ldap', '~> 0.2'
  
end
