# Set up initializers
Dir["./initialize/**/*.rb"].each { |int| require int }

# Include all of the models
Dir["./models/**/*.rb"].each { |model| require model }

# Routes
require 'erb'

class MainApp < Sinatra::Base
  get "/css/:sheet.css" do |sheet|
    sass :"css/#{sheet}"
  end

  get "/" do
    @local_ip = LOCAL_IP
    # set up
    capability = Twilio::Util::Capability.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    # allow outgoing calls to an application
    capability.allow_client_outgoing ENV['TWILIO_APP_ID']
    # generate the token string
    @token = capability.generate
    erb :index
  end
  
  get "/add_track" do
    t = Hallon::Track.new( params[:spotify_url] )
    PLAYLIST.insert(0, t)
        
    state_changed = false
    PLAYLIST.on(:playlist_state_changed) { state_changed = true }
    HALLON_SESSION.wait_for { state_changed && ! PLAYLIST.pending? }
    
    puts "DONE BABY!!!"
    
  end

  post '/twilio' do
    '<Response>
<Dial>
<Conference>1234</Conference>
</Dial>
</Response>'
  end
end
