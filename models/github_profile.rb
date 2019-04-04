GithubProfile = Struct.new(:id, :username, :avatar_url, :profile_url, keyword_init: true) do
  def as_json
    {
      id: id,
      username: username,
      avatar_url: avatar_url,
      profile_url: profile_url
    }
  end
end