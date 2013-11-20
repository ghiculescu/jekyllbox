require 'daemons'

options = {
  :app_name   => "jekyllbox",
  :dir_mode   => :script,
  :ontop      => false,
  :backtrace  => true,
  :monitor    => true
}

Daemons.run(File.join(File.dirname(__FILE__), 'jekyllbox.rb'), options)