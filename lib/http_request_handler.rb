# frozen_string_literal: true

require 'faraday'
require 'faraday-http-cache'

module HttpRequestHandler
  def self.client
    Faraday.new do |builder|
      builder.use Faraday::HttpCache, serializer: MultiJson
      builder.adapter Faraday.default_adapter
    end
  end

  def self.handle_response(response)
    case response&.status
    when 403 then raise HttpForbiddenError
    when 401 then raise HttpUnauthorizedError
    when nil then raise HttpConnectionError
    else
      yield MultiJson.load(response.body, symbolize_keys: true)
    end
  end

  class Error < StandardError; end
  class HttpForbiddenError < Error; end
  class HttpUnauthorizedError < Error; end
  class HttpConnectionError < Error; end
end
