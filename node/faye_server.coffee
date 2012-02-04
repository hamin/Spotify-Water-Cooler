http = require 'http'
faye = require 'faye'

# ********* Utility Stuff ***********
process.on 'uncaughtException', (err) ->
  console.log "Error: #{err}"
# Handle non-Bayeux requests
server = http.createServer (request, response) ->
  response.writeHead 200, {'Content-Type': 'text/plain'}
  response.write 'Hello, non-Bayeux request'
  response.end
#  Server logging
serverLog =
  incoming: (message, callback) ->
    if message.channel == '/meta/subscribe'
      logWithTimeStamp "CLIENT SUBSCRIBED Client ID: #{message.clientId}"
    if message.channel.match(/\/users\/*/)
      logWithTimeStamp "USER MESSAGE ON CHANNEL: #{message.channel}"
    callback(message)

logWithTimeStamp = (logMessage) ->
  timestampedMessage =  "#{Date()} | #{logMessage}"
  console.log timestampedMessage
# *************************************
  
bayeux = new faye.NodeAdapter( mount: '/faye', timeout: 45)

bayeux.addExtension serverLog
bayeux.attach server
console.log "Starting Faye server on port 5222"
server.listen 5222