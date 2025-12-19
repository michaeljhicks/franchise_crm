Geocoder.configure(
  lookup: :google,

  # API key for geocoding service
  # We will set this in your credentials file in the next step
  api_key: Rails.application.credentials.dig(:google_maps, :api_key),

  # Use HTTPS for lookup requests? (if supported)
  use_https: true,

  # Calculation options
  units: :mi,                 # :km for kilometers or :mi for miles
  distances: :linear          # :spherical or :linear
)