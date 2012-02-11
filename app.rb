# Set up initializers
Dir["./initialize/**/*.rb"].each { |int| require int }

# Include all of the models
Dir["./models/**/*.rb"].each { |model| require model }

# Routes
require 'erb'
require './partials'

class MainApp < Sinatra::Base
  helpers Sinatra::Partials
  
  get '/stylesheets/:name.css' do
    content_type 'text/css', :charset => 'utf-8'
    scss(:"stylesheets/#{params[:name]}")
  end

  get "/" do
    @local_ip = LOCAL_IP
    capability = Twilio::Util::Capability.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    capability.allow_client_outgoing ENV['TWILIO_APP_ID']
    @token = capability.generate
    @playlist_tracks = PLAYLIST.tracks.map do |t| 
      {
        :playlist_index => t.index , 
        :artist => t.artist.nil? ? nil : t.artist.name, 
        :name => t.name,
        :image_url => t.album.nil? ? nil : t.album.cover(false).to_url
      }
    end.compact.sort_by{|h| h[:playlist_index]}
    erb :index
  end
  
  get "/add_track" do
    t = Hallon::Track.new( params[:spotify_url] )
    PLAYLIST.insert(0, t)
    state_changed = false
    PLAYLIST.on(:playlist_state_changed) { state_changed = true }
    HALLON_SESSION.wait_for { state_changed && ! PLAYLIST.pending? }
    
    content_type(:json)
    playlist_tracks = PLAYLIST.tracks.map{|t| {:playlist_index => t.index , :artist => (t.artist.nil? ? nil : t.artist.name), :name => t.name}}.sort_by{|h| h[:playlist_index]}
    puts playlist_tracks
    playlist_tracks.to_json    
  end

  post '/twilio' do
    '<Response>
<Dial>
<Conference>1234</Conference>
</Dial>
</Response>'
  end
end
