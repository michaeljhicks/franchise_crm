# Pin npm packages by running ./bin/importmap

pin "application"

# config/importmap.rb

# We are pointing directly to the CDN to bypass your local download/SSL issues
pin "@hotwired/turbo-rails", to: "https://ga.jspm.io/npm:@hotwired/turbo-rails@8.0.4/app/javascript/turbo/index.js"