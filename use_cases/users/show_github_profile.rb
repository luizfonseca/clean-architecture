require 'faraday'
require './lib/http_request'

module UseCases
  module Users
    class ShowGithubProfile
      # include UseCases::Common

      def self.perform(search_param)
        new.perform(search_param)
      end

      def initialize; end

      def perform(username)
        fetch_latest_api_posts(username)
      end

      private

      # Find users named "Adam" with more than 42 repos and 1000 followers
      def fetch_latest_api_posts(username)
        response = HttpRequest.client.get "https://api.github.com/search/users?q=#{username}"
        json_response = MultiJson.load(response.body, symbolize_keys: true)

        sorted_profiles_by_id_asc json_response[:items]
      end

      def sorted_profiles_by_id_asc(items)
        items.map! { |profile| transform_to_github_profile(profile) }

        items.sort_by { |profile| profile[:id].to_i }
      end

      def transform_to_github_profile(profile)
        Presenters::GithubProfile.new(profile).as_json
      end
    end
  end
end