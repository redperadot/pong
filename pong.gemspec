Gem::Specification.new do |spec|
  
  spec.name                  = 'pong'
  spec.version               = '1.0.0'
  spec.summary               = "Monitor network addresses from the command line."
  
  spec.author                = "Cody Hannafon"
  spec.email                 = "redperadot@darkgem.net"
  spec.homepage              = 'https://github.com/redperadot/pong'
  spec.licenses              = 'Apache-2.0'
  
  spec.required_ruby_version = '2.1.4'
  spec.requirements          = ['net-ping', 'colorize']
  
  spec.bindir                = 'bin'
  spec.executables           = 'pong'
  spec.files                 = Dir['lib/*.rb'] + Dir['bin/*']
  
  spec.post_install_message  = 'May the command line live forever.'
  
end
