(function() {
  var bayeux, faye, http, logWithTimeStamp, server, serverLog;
  http = require('http');
  faye = require('faye');
  process.on('uncaughtException', function(err) {
    return console.log("Error: " + err);
  });
  server = http.createServer(function(request, response) {
    response.writeHead(200, {
      'Content-Type': 'text/plain'
    });
    response.write('Hello, non-Bayeux request');
    return response.end;
  });
  serverLog = {
    incoming: function(message, callback) {
      if (message.channel === '/meta/subscribe') {
        logWithTimeStamp("CLIENT SUBSCRIBED Client ID: " + message.clientId);
      }
      if (message.channel.match(/\/users\/*/)) {
        logWithTimeStamp("USER MESSAGE ON CHANNEL: " + message.channel);
      }
      return callback(message);
    }
  };
  logWithTimeStamp = function(logMessage) {
    var timestampedMessage;
    timestampedMessage = "" + (Date()) + " | " + logMessage;
    return console.log(timestampedMessage);
  };
  bayeux = new faye.NodeAdapter({
    mount: '/faye',
    timeout: 45
  });
  bayeux.addExtension(serverLog);
  bayeux.attach(server);
  console.log("Starting Faye server on port 5222");
  server.listen(5222);
}).call(this);
