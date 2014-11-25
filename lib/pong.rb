module Scripter extend self
  
  def clean_exit(message = nil)
    Signal.trap("INT") { |signo| Scripter.tput('clear'); puts; puts message if message; exit 0 }
  end
  
  def parse_version(ver)
    ver = ver.to_s.split('.')
    ver = { major: ver[0].to_i, minor: ver[1].to_i, patch: ver[2].to_i }
  end
  
  def tput(set, unset = nil)
    system 'tput', set
    at_exit { system 'tput', unset } unless unset.nil?
  end
  
  def clear_screen
    rows = $stdin.winsize[0]
    cols = $stdin.winsize[1]
    chrs = rows * cols - cols
    self.tput('home')
    print ' ' * chrs
    system("tput cup #{cols} 0")
  end
  
  def center(line)
    cols = $stdin.winsize[1]
    marg = ' ' * ((cols - line.to_s.length) / 2 )
    return marg + line.to_s
  end
  
end

class Pong
  
  attr_reader :ball, :addr, :name
  attr_writer :sleep, :tmout, :colr
  @@sleep = 2
  @@tmout = 3
  @@refsh = Time.now.to_i
  @@scren = lambda {{ rows: $stdin.winsize[0], cols: $stdin.winsize[1] }}
  @@colrs = [:default, :black, :green, :red, :light_black, :light_red, :light_green, :light_yellow, :light_blue, :light_magenta, :light_cyan, :light_white]
  
  def initialize(host)
    @name = name
    @host = Net::Ping::External.new(host); @host.timeout = @@tmout
    @addr = @host.host.to_s
    @colr = String.colors.sample while @colr.nil? || @@colrs.include?(@colr); @@colrs.push(@colr)
    @ball = { aval: false, prev: false, chng: Time.now, tabl: Array.new }
    @padl = Thread.new {
      loop do
        sleep(@@sleep)
        @ball[:aval] = @host.ping?
        next if @ball[:prev] == @ball[:aval]
        @ball[:chng] = Time.now
        @ball[:prev] = @ball[:aval]
        @ball[:tabl] << [ @ball[:chng].to_i, "#{@ball[:chng].strftime('%y:%m:%d:%H:%M:%S')}" + ' • '.colorize(@colr) + "#{@addr} is #{( @ball[:aval] ? 'up'.green : 'down'.red )}." ]
        Thread.current[:state] = @ball
      end
    }
    
  end
  
  def status
    '[' + @addr.colorize(@colr) + '|' + ( @ball[:aval] ? '●'.green : '●'.red ) + ']'
  end
  
  def self.table(lines)
    tables = Array.new
    hosts.each { |host| tables.concat(host.ball[:tabl]) }
    tables.sort.map { |item| item[1] }[0..lines]
  end
  
  def self.refresh
    changes = Array.new
    hosts.each { |host| changes << host.ball[:chng].to_i }
    return false if changes.sort.last < @@refsh
    @@refsh = Time.now.to_i
    return true
  end
  
  def self.hosts
    ObjectSpace.each_object(self).to_a
  end
    
  def self.net
    stat_bar = String.new
    hosts.each { |host| stat_bar << host.status }
    return stat_bar
  end
  
  def self.monitor
    loop do
      @@scren = { rows: $stdin.winsize[0], cols: $stdin.winsize[1] }
      Scripter.clear_screen
      table(@@scren[:rows] - 2).each { |line| puts line }
      puts '⎓' * (@@scren[:cols] - 1)
      puts net
      sleep(@@sleep) until refresh
    end
  end
  
  def self.splash
    Scripter.tput('civis', 'cvvis')
    
    relnam = %x(dscl . read /Users/`whoami` RealName).split[1..2]
    aspeed = 0.06
    runs   = (@@tmout * (aspeed * 100)).round
    logo   = [
      '      :::::::::   ::::::::  ::::    :::  ::::::::',
      '     :+:    :+: :+:    :+: :+:+:   :+: :+:    :+:',
      '    +:+    +:+ +:+    +:+ :+:+:+  +:+ +:+        ',
      '   +#++:++#+  +#+    +:+ +#+ +:+ +#+ :#:         ',
      '  +#+        +#+    +#+ +#+  +#+#+# +#+   +#+#   ',
      ' #+#        #+#    #+# #+#   #+#+# #+#    #+#    ',
      '###         ########  ###    ####  ########      ',
    ]
    mesage = [ "Getting ready to start a game of ping pong!", "Loading #{hosts.size} hosts..." ]
    colors = [ :cyan, :magenta, :yellow ]
    header = "\n" * (( $stdin.winsize[0] - logo.size ) / 2 - 2 )

    Scripter.tput('clear')
    (runs).times do |i|
      print header
      logo.each do |line|
        puts Scripter.center(line).colorize(colors[0])
        sleep(aspeed)
      end
      puts Scripter.center('╍' * (logo[0].length + 2))
      mesage.each { |line| puts Scripter.center(line) }
      colors.rotate!
      Scripter.tput('home')
    end
    
  end
  
  private_class_method :net, :table, :hosts, :refresh
  
end