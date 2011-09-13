require 'digest/md5'

class PlayerController < ApplicationController

  def index
    puts 'inside index'
  end

  def upload
  end

  def delete
  end

  def current_song
    info = Player.current_song_info
    puts "\n\n#{__LINE__}::#{info.inspect}\n\n"
    render :json => {url: url_from_info(info)}.merge(info)
  end

  def next_song
    puts "next song"
    Player.next_song!
    Pusher['audio-controller'].trigger('get-new-song', params)
    #render :json => {url: url_from_info(Player.current_song_info)}
    head :ok
  end

  def vote_song_up
    Playlist.vote_song_up(params[:s_id])
  end

  def vote_song_down
    Playlist.vote_song_down(params[:s_id])
  end

  def vote_to_skip
    Playlist.vote_skip(params[:s_id])
  end


  private

    def url_from_info(hsh)
      "assets/#{hsh['artist']}/#{hsh['album']}/#{hsh['song']}"
    end

end
