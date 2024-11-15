Rails.application.routes.draw do
  mount GraphqlPlayground::Rails::Engine, at: '/graphiql', graphql_path: '/graphql' if Rails.env.development?
  post '/graphql', to: 'graphql#execute'

  constraints ->(request) { request.path.exclude?('active_storage') } do
    match '*unmatched', to: 'application#handle_no_route', via: :all
  end
end
