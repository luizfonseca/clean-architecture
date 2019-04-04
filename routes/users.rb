# frozen_string_literal: true

PassengerServer.route 'users' do |r|
  # shared between all routes inside this scope
  shared[:user] = { email: r.headers['x-user-email'], token: r.headers['x-user-token'] }
  shared[:organization] = r.headers['x-organization-id']

  r.get String do |username_to_search|
    response.cache_control public: true, max_age: 60
    UseCases::Users::ListGithubProfilesByUsername.perform(username_to_search)
  end

  r.post 'anonymize', String do |user_id|
    UseCases::Users::AnonymizeAccount.perform(user_id)
  end
end

PassengerServer.error do |exception|
  halt_with_error(:user_doesnt_exist) if exception.eql UserService::OauthCancelledAccountError
end
