# frozen_string_literal: true

module Types
  class MutationType < BaseObject
    field :sign_up, mutation: Mutations::SignUp
    field :sign_in, mutation: Mutations::SignIn
    field :create_video, mutation: Mutations::CreateVideo
  end
end
