var audioController = PusherI.subscribe('audio-controller');

refreshAudioTag = function() {
  $.get('player/current_song', function(data) {
    var audioSection = $('section#player');
    var audio = $('<audio>', {
      controls : 'controls',
      autoplay : true,
      id:        'audio-player'
    });
    audio.bind('ended', function() {
        $.get('player/next_song');
    });
    $('<source>').attr('src', data.url).appendTo(audio);
    audioSection.html(audio);
  });
};

audioController.bind('get-new-song', function(message){
  refreshAudioTag();
});

$(document).ready(function() {
    var audioSection = $('section#player');
    $('a.html5').click(function() {

      refreshAudioTag();

        //var audio = $('<audio>', {
          //controls : 'controls',
          //autoplay : true,
          //id:        'audio-player'
        //});

        //var url = null;
        //$.ajax({
          //url: 'current_song_url',
          //type: 'GET',
          //async: false,
          //cache: false,
          //error: function(){
            //return false;
          //},
          //success: function(data) {
            //url = data.url;
          //}
        //});
        //$('<source>').attr('src', url).appendTo(audio);
        //audioSection.html(audio);
        return false;
    });
    $('a.refresh-audio-tag').click(function(){
      refreshAudioTag();
      return false;
    });
});
