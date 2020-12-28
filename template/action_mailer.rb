ActionMailer::Base.default_url_options = {
  host: ENV['EMAIL_URL_HOST'],
  port: ENV['EMAIL_URL_PORT']
}

if Rails.env.development?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = { address: 'mail', port: 1025 }
elsif Rails.env.production?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.smtp_settings = {
    port: ENV['SMTP_PORT'],
    address: ENV['SMTP_SERVER'],
    user_name: ENV['SMTP_USERNAME'],
    password: ENV['SMTP_PASSWORD'],
    domain: ENV['EMAIL_URL_HOST'],
    authentication: :plain
  }
end
