# frozen_string_literal: true

require 'faraday'
require 'faraday-http-cache'

module HttpRequestInteractor
  def self.client
    Faraday.new do |builder|
      # builder.use Faraday::HttpCache, serializer: MultiJson
      builder.adapter Faraday.default_adapter
    end
  end

  def handle_response(response)
    case response&.status
    when 403 then raise HttpForbiddenError, response.body['message']
    when 401 then raise HttpUnauthorizedError, response.body['message']
    else
      yield
    end
  end

  class Error < StandardError; end
  class HttpForbiddenError < Error; end
end
