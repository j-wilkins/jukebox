# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


class Seed

  class << self

    MUSIC_DIR = File.expand_path(File.join(File.dirname(File.dirname(__FILE__)),
                                          'app', 'assets', 'music'))

    FILE_TYPES = %w(.mp3 .mp4 .ogg)

    def redis
      Jukebox::REDIS
    end

    def do_it!(options=nil)
      Player.drop_jukebox
      Dir.foreach(MUSIC_DIR) do |d|
        fpath = File.join(MUSIC_DIR, d)
        next unless File.directory?(fpath)
        next if (d == '.' || d == '..')
        puts File.join(fpath, '**/*')
        Dir.glob(File.join(fpath, '**', '*')).each do |s|
          next unless FILE_TYPES.include?(File.extname(s))
          song = File.basename(s)
          album = File.basename(File.dirname(s))
          artist = File.basename(File.dirname(File.dirname(s)))
          puts "#{artist} -- #{album} -- #{song}"
          p Player.add_to_index({artist: artist, album: album, song: song})
        end
      end
    end

  end

end

Seed.do_it!(:seed)
