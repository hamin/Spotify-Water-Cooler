/*!
 * jQuery Spotify Metadata API Plugin v0.0.1
 * http://rds.github.com/
 *
 * Copyright 2011 Richard Smith / May Contain Cocoa
 */

(function($) {
  function grepWithLimit(elems, callback, limit, inv) {
    var ret = [], retVal;
    inv = !!inv;
    
    // Go through the array, only saving the items
    // that pass the validator function
    for ( var i = 0, length = elems.length; i < length; i++ ) {
      retVal = !!callback( elems[ i ], i );
      if ( inv !== retVal ) {
        ret.push( elems[ i ] );
      }
      if (ret.length >= limit) {
        break
      }
    }
    
    return ret;
  }
    
  $.spotifydata = function(method) {
    var methods = spotifydataMethods;
    if (methods[method]) {
      return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else {
      $.error('jQuery.spotifydata#' +  method + ' does not exist');
    }
  }
  
  var spotifydataMethods = {
    filter: function(tracks, twoLetterCountryCode, limit) {
      if (tracks.tracks) {
        tracks = tracks.tracks;
      }
      if (!tracks[0]) {
        return $.error('No tracks provided');
      } else if (!tracks[0]['album']['availability']) {
        return $.error('No tracks provided');
      }
      if (limit) {
        limit = 100;
      }
      if (twoLetterCountryCode == 'UK') {
        twoLetterCountryCode = 'GB';
      }
      var regex = new RegExp('('+twoLetterCountryCode+'|worldwide)', 'g')
      tracks = grepWithLimit(tracks, function(track, i) {
        return track.album.availability.territories.search(regex) >= 0;
      }, 1);
      return tracks;
    },
    
    lookup: function(uri, options, callback) {
      var data = { uri: uri };
      $.extend(options, {});
      if (options.extras) {
        data['extras'] = options.extras;
      }
      return $.get('http://ws.spotify.com/lookup/1/', data, callback, options.dataType || 'json');
    },

    search: function(query, options, callback) {
      if (typeof options === 'function') {
        callback = options;
      }
      if (typeof options !== 'objet') {
        options = {}
      }
      if ($.isArray(query)) {
        return $.each(query, function(i, query) {
          return spotifydataMethods.search(query, options, callback)
        })
      } else {
        var data = { q: query, page: options.page || 1 };
        return $.get('http://ws.spotify.com/search/1/' + (options.method || 'track'), data, callback, options.dataType || 'json')
      }
    },
    
    track: function(query, options, callback) {
      return spotifydataMethods.search(query, options, callback);
    },

    artist: function(query, options, callback) {
      return spotifydataMethods.search(query, $.extend(data, { method: 'artist' }), callback);
    },

    album: function(query, options, callback) {
      return spotifydataMethods.search(queryquery, $.extend(options, { method: 'album' }), callback);
    }
  }
})(jQuery);