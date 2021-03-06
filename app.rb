# frozen_string_literal: true

require 'roda'
require 'multi_json'
require 'sequel'

# Main App class
class PassengerServer < Roda
  plugin :error_handler
  plugin :shared_vars
  plugin :multi_route
  plugin :status_handler
  plugin :request_headers
  plugin :caching
  plugin :json, serializer: ->(o) { MultiJson.dump(o) }
  plugin :json_parser, parser: ->(o) { MultiJson.load(o, symbolize_keys: true) }

  # Enabling routes to be used as separate files
  route(&:multi_route)

  Dir['./routes/**/*.rb',
      './models/**/*.rb',
      './use_cases/**/*.rb',
      './presenters/**/*.rb'].each { |f| require f }

  status_handler 404 do
    { code: 'PAS-404', message: 'The page you are looking for doesn\'t exist.' }
  end

  status_handler 500 do
    { code: 'PAS-500', message: 'An error occured.' }
  end
end

