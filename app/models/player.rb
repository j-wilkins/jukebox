
class Player

  class << self
    def redis
      Jukebox::REDIS
    end

    def index(start = 0, stop = 100)
     redis.lrange('index', start, stop)
    end

    def add_to_index(hash)
      redis.rpush('index', hash.to_json)
      s_id = redis.llen('index') - 1
      index_song_info(hash.merge({song_id: s_id}))
    end

    def drop_from_index(hash)
      redis.lrem('index', 1, hash.to_json)
      drop_song_from_indices(hash)
    end

    def current_song_id
      s_id = redis.get('current.song')
      if s_id.nil?
        s_id = rand(redis.llen('index'))
        set_current_song(s_id)
      end
      s_id
    end

    def song_id(song_name)
      redis.get("song:#{song_name}")
    end

    def current_song_info
      JSON.parse(redis.lindex('index', current_song_id))
    end

    def song_info(song_id)
      JSON.parse(redis.lindex('index', song_id))
    end

    def set_current_song(song_id)
      redis.set('current.song',song_id )
    end

    def vote_skip(song_id)
      redis.incr('skip.current')
    end

    def vote_song_down(song_id)
      redis.decr(song_id)
    end

    def vote_song_up(song_id)
      redis.incr(song_id)
    end

    def next_song!(playlist_id = 'default')
      pl = "playlist:#{playlist_id}"
      build_random_playlist(playlist_id) if redis.llen(pl) == 0
      s_id = redis.lpop(pl)
      set_current_song(s_id)
      redis.rpush(pl, redis.lindex('index', rand(redis.llen('index'))))
      s_id
    end

    def playlist(playlist_id = 'default')
      redis.lrange("playlist:#{playlist_id}", 0, redis.llen(playlist_id))
    end

    def build_random_playlist(playlist_id = 'default')
      index_length = redis.llen('index')
      20.times {redis.rpush("playlist:#{playlist_id}", rand(index_length))}
      playlist_id
    end

    def add_song_to_playlist(playlist_id, song_id)
      redis.rpush("playlist:#{playlist_id}", song_id)
    end

    def drop_song_from_playlist(playlist_id, song_id)
      redis.lrem("playlist:#{playlist_id}", 1, song_id)
    end

    def index_song_info(hsh)
      redis.sadd("artist:#{hsh[:artist]}", hsh[:song_id])
      redis.sadd("album:#{hsh[:album]}", hsh[:song_id])
      redis.set("song:#{hsh[:song]}", hsh[:song_id])
    end

    def drop_song_from_indices(hsh)
      redis.srem("artist:#{hsh[:artist]}", 1, hsh[:song_id])
      redis.srem("album:#{hsh[:album]}", 1, hsh[:song_id])
      redis.del("song:#{hsh[:name]}")
    end

    def drop_jukebox
      k = redis.keys('*')
      redis.del(*k) unless k == []
    end
  end
end
