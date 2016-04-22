Recaptcha.configure do |config|
  config.public_key  = ENV['CAPTCHA_PUBLIC_KEY']
  config.private_key = ENV['CAPTCHA_PRIVATE_KEY']
  config.use_ssl_by_default = false
end
