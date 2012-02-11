$(document).ready(function() {
  
  
  $('#search-form').bind('submit',function(event) {
    event.preventDefault();
    
    function trimCrap(line) {
      return (typeof line == 'string') ? $.trim(line).replace(/ \W /gi, ' ').replace(/\s+/gi, ' ') : line;
    };
    
    tracks = $.map($.unique($('#search').val().split('\n')), function(track) {
      return (/\w/).exec(track) ? trimCrap(track) : null; 
    });
    
    var result, results = [], resultsCount = 0, foundResultsCount = 0, track, spotifyTracks;
    
    $.spotifydata('search', tracks, function lambda(data) {
			result = {};
			result['info'] = data.info;
			if (data.tracks.length > 0) {
        apiResults = $.spotifydata('filter', data.tracks, 'US', 10);
				result['track'] = apiResults[0];
				spotifyTracks = data.tracks.slice(0,9);
				
				if (!result.track) {
					result['unavailableTrack'] = data.tracks[0];
				}
				result['result'] = data.tracks.indexOf(result.track) + 1;
			} else {
				var altQuery = result.info.query.replace(/(\(|\[).+(\)|\])/,'');

				if (altQuery != result.info.query) {
					$.spotifydata('search', altQuery, lambda);
				}
			}
			results[resultsCount++] = result;
			result['found'] = !!result.track;
			if (result.track) {
				foundResultsCount++;
			};
      $("#search-results").html('');
      
      $.each(spotifyTracks, function(index, val) {
        html = "<li class='spotify-track' id='" + val.href +  "'<span><strong>" + val.artists[0].name + ": </strong><i>" + val.name + "</i></span></li>";
        $("#search-results").append(html);
      }); // End of inserting tracks html
		}); // End of spotify search
  }); // End of search-form bind
  
  $("#search-results li.spotify-track").live("click", function(event) {
    playlistName = $("#current-playlist").val();
    $.get('/add_track', {spotify_url: $(this).attr('id'), playlist_name: playlistName}, function(data, textStatus, xhr) {
      //optional stuff to do after success
      $("#playlist-tracks").html(data);
    }); 
  });
  
  
  // Select Playlist
  $("#current-playlist").bind('change', function(event) {
    // Act on the event
    playlistName = $(this).val();
    
    $.get('/change_playlist', {playlist_name: playlistName}, function(data, textStatus, xhr) {
      //optional stuff to do after success
      $("#playlist-tracks").html(data);
    });
  });
  
  // Chat Stuff
  var conversation = $("#chat-container ul");
  var nickname = null;
  var subscription = client.subscribe('/chat', function(message) {
    conversation.append('<li>(<small>' + message.cleanTime + '</small>) <strong>' + message.nick + ' &mdash; </strong>' + message.msg + '</li>');
    conversation.scrollTop(999999); // Hack: autoscroll down to last message
  });
  
  $('#login-form').bind('submit',function(event) {
    event.preventDefault();  
    nickname =  $('#login-nick').val();
    $('#chat-login').hide();
    $('#chat-container').show();
    // $('#what-to-do').removeClass('center');
  });
  
  $('#chat-form').bind('submit',function(event) {
    event.preventDefault();
    picture_id = $('.photo').attr('id');
    date = new Date();
    cleanDate = date.getHours() + ':' + date.getMinutes();
    msgDate = date.getHours() + ':' + date.getMinutes();
    message = { picture_id: picture_id, nick: nickname, cleanTime: cleanDate, time: date, msg: $('#message').val() };
    client.publish('/chat', message);
    $('#message').val('').focus();
  });
  
  // Twilio Stuff
  var connection;
  function call() {
    connection = Twilio.Device.connect();
  }

  function hangup() {
    connection.disconnect();
  }
  
  $('#hangup').hide();
  
  $('#call').click(function(e) {
    e.preventDefault();
    call();
    $(this).hide();
    $('#hangup').show();
    $('#chat-login grid_6.alpha.right').hide();
  });
  
  $('#hangup').click(function(e) {
    e.preventDefault();
    hangup();
    $(this).hide();
    $('#call').show();
  });
  
  
});