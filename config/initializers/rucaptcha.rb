redis_config = Rails.application.config_for(:redis)
RuCaptcha.configure do
  self.cache_store = [:redis_store, redis_config['host'], redis_config]
end