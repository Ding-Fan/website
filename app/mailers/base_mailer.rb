class BaseMailer < ActionMailer::Base
  default from: Figaro.env.MAILER_SENDER
  default charset: "utf-8"
  default content_type: "text/html"
  default_url_options[:host] = Figaro.env.MAIL_HOST

  layout "mailer"
  helper :topics, :users
end
