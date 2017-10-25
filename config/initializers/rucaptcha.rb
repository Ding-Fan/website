redis_config = Rails.application.config_for(:redis)
RuCaptcha.configure do
  self.cache_store = [:mem_cache_store, redis_config['host'], redis_config]
end