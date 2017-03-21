module HealthCheck
  class RedisHealthCheck
    extend BaseHealthCheck
    
    REDIS_CONFIG = YAML.load( File.open( Rails.root.join("config/redis.yml") ) ).symbolize_keys[Rails.env.to_sym]

    def self.check
      unless defined?(::Redis)
        raise "Wrong configuration. Missing 'redis' gem"
      end
      res = if REDIS_CONFIG
        ::Redis.new(REDIS_CONFIG).ping
      else
        ::Redis.new.ping
      end
      
      res == 'PONG' ? '' : "Redis.ping returned #{res.inspect} instead of PONG"
    rescue Exception => e
      create_error 'redis', e.message
    end
  end
end
