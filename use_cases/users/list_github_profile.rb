require 'faraday'
require './lib/http_request_handler'

module UseCases
  module Users
    class ListGithubProfilesByUsername
      def self.perform(search_param)
        new.perform(search_param)
      end

      def initialize; end

      def perform(username)
        list_profiles_matching_username(username)
      end

      private

      def list_profiles_matching_username(username)
        response = HttpRequestHandler.client.get "https://api.github.com/search/users?q=#{username}"

        HttpRequestHandler.handle_response(response) do |parse_response_body|
          sorted_profiles_by_id_asc parse_response_body[:items]
        end

      rescue HttpRequestHandler::Error => error
        raise StandardError, "Failed to communicate with Github. #{error}"
      end

      def sorted_profiles_by_id_asc(items)
        items&.map! { |profile| transform_to_github_profile(profile) }

        items.sort_by { |profile| profile[:id] }
      end

      def transform_to_github_profile(github_profile)
        GithubProfile.new(
          id:          github_profile.fetch(:id),
          username:    github_profile.fetch(:login),
          avatar_url:  github_profile.fetch(:avatar_url),
          profile_url: github_profile.fetch(:html_url)
        ).as_json
      end
    end
  end
end