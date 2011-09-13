# Set Resque to use the right redis
# these steps aren't all necessary, but it allows for maximum amount of control
# we can decide later if it's worth it.
r_conf = Jukebox::Application.config.database_configuration['redis'][Rails.env]
redis = Redis.new(host: r_conf['host'], port: r_conf['port'])
r_conf['namespace'] ||= :jukebox
Jukebox::REDIS = Redis::Namespace.new(r_conf['namespace'], redis: redis)

