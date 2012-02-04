require "rubygems"
require "bundler"
Bundler.require

set :root, File.dirname(__FILE__)
set :views, File.dirname(__FILE__) + "/views"
set :public, File.dirname(__FILE__) + "/public"

use Rack::Session::Cookie, :secret => 'oiauf98asdhkjbfdsf87ds'
use Rack::MethodOverride

require 'socket'

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

use Rack::Static, :urls => [ '/images', '/js' ], :root => "public"
require "./app.rb"

#map '/' do
  run MainApp
#end
