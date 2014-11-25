Gem::Specification.new do |spec|
  
  spac.name                  = 'pong'
  spec.version               = '0.3.0'
  spec.summary               = "Monitor network addresses."
  
  spec.author                = "Cody Hannafon"
  spec.email                 = "redperadot@darkgem.net"
  spec.homepage              = 'https://github.com/redperadot/pong'
  spec.licenses              = 'Apache-2.0'
  
  spec.required_ruby_version = '2.1.4'
  spec.requirements          = ['net-ping', 'colorize']
  
  spac.bindir                = 'bin'
  spec.executables           = Dir['bin/*']
  spec.files                 = Dir['lib/*.rb'] + Dir['bin/*']
  
  spec.post_install_message  = 'May the command line live forever.'
  
end
