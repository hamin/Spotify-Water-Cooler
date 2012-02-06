# Set up initializers
Dir["./initialize/**/*.rb"].each { |int| require int }

# Include all of the models
Dir["./models/**/*.rb"].each { |model| require model }

# Routes
require 'erb'

class MainApp < Sinatra::Base
  
  get '/stylesheets/:name.css' do
    content_type 'text/css', :charset => 'utf-8'
    scss(:"stylesheets/#{params[:name]}")
  end

  get "/" do
    @local_ip = LOCAL_IP
    capability = Twilio::Util::Capability.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    capability.allow_client_outgoing ENV['TWILIO_APP_ID']
    @token = capability.generate
    erb :index
  end
  
  get "/add_track" do
    t = Hallon::Track.new( params[:spotify_url] )
    PLAYLIST.insert(0, t)
    state_changed = false
    PLAYLIST.on(:playlist_state_changed) { state_changed = true }
    HALLON_SESSION.wait_for { state_changed && ! PLAYLIST.pending? }
    # puts PLAYLIST.tracks.map{|t| {:artist => (t.artist.nil? ? nil : t.artist.name), :name => t.name}}
    # playlist_json = PLAYLIST.tracks.map{|t| {:artist => (t.artist.nil? ? nil : t.artist.name), :name => t.name}}.to_json
    # JSON.parse playlist_json
    puts "OK"
  end

  post '/twilio' do
    '<Response>
<Dial>
<Conference>1234</Conference>
</Dial>
</Response>'
  end
end
