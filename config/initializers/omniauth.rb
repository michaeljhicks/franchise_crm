# config/initializers/omniauth.rb

# This tells OmniAuth to allow both GET and POST requests for authentication.
# This resolves the conflict with Devise's link helpers.
OmniAuth.config.allowed_request_methods = [:post, :get]
OmniAuth.config.silence_get_warning = true