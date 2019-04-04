require 'faraday'
require 'faraday-http-cache'

module HttpRequest
  def self.client
    Faraday.new do |builder|
      builder.use Faraday::HttpCache
      builder.adapter Faraday.default_adapter
    end
  end
end