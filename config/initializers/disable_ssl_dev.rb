# config/initializers/disable_ssl_dev.rb

if Rails.env.development?
  require 'openssl'
  # Bypass SSL verification in development to allow Google API calls
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  puts "⚠️ SSL Verification disabled for Development ⚠️"
end