require "rubygems"
require "bundler"
Bundler.require

require 'socket'
require "./app.rb"

configure do
  set :scss, {:style => :compact, :debug_info => false}
  Compass.add_project_configuration(File.join(Sinatra::Application.root, 'config', 'compass.rb'))
end

use Faye::RackAdapter, :mount => '/faye', :timeout => 45
run MainApp