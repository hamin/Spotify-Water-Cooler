require "rubygems"
require "bundler"
Bundler.require

require 'socket'

# Local IP solution from here: http://coderrr.wordpress.com/2008/05/28/get-your-local-ip-address/
def local_ip
  orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

  UDPSocket.open do |s|
    s.connect '64.233.187.99', 1
    s.addr.last
  end
ensure
  Socket.do_not_reverse_lookup = orig
end
LOCAL_IP = local_ip

require "./app.rb"

configure do
  set :scss, {:style => :compact, :debug_info => false}
  Compass.add_project_configuration(File.join(Sinatra::Application.root, 'config', 'compass.rb'))
end

run MainApp