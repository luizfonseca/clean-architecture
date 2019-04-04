module Presenters
  class GithubProfile
    def initialize(github_profile)
      @github_profile = github_profile
    end

    def as_json
      {
        id:          @github_profile.fetch(:id, nil),
        username:    @github_profile.fetch(:login),
        avatar_url:  @github_profile.fetch(:avatar_url),
        profile_url: @github_profile.fetch(:html_url)
      }
    rescue ArgumentError, KeyError => error
      raise StandarError, "Missing Github Key from Profile. Full Error: #{error}"
    end
  end
end
