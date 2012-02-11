require "rubygems"
require "bundler"
Bundler.require

require 'socket'
require "./app.rb"


def load_config(file) 
  if File.exist?(file) 
    yaml = YAML.load_file(file)
    ENV['HALLON_APPKEY'] = yaml['HALLON_APPKEY']
    ENV['HALLON_USERNAME'] = yaml['HALLON_USERNAME']
    ENV['HALLON_PASSWORD'] = yaml['HALLON_PASSWORD']
    
    ENV['TWILIO_ACCOUNT_SID'] = yaml['TWILIO_ACCOUNT_SID']
    ENV['TWILIO_AUTH_TOKEN'] = yaml['TWILIO_AUTH_TOKEN']
    ENV['TWILIO_NUMBER'] = yaml['TWILIO_NUMBER']
    ENV['TWILIO_APP_ID'] = yaml['TWILIO_APP_ID']
  else
    return "Please setup config.yml"  
  end 
end

configure do
  load_config "./config.yml"
  
  HALLON_SESSION = Hallon::Session.initialize IO.read(ENV['HALLON_APPKEY']) do
    on(:log_message) do |message|
      puts "[LOG] #{message}"
    end
  end
  
  HALLON_SESSION.login!(ENV['HALLON_USERNAME'], ENV['HALLON_PASSWORD'])
  puts "Successfully logged in!"
  
  set :scss, {:style => :compact, :debug_info => false}
  Compass.add_project_configuration(File.join(Sinatra::Application.root, 'config', 'compass.rb'))
end

use Faye::RackAdapter, :mount => '/faye', :timeout => 45
run MainApp