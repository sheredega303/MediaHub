# frozen_string_literal: true

module Types
  class MutationType < BaseObject
    field :sign_up, mutation: Mutations::SignUp
    field :sign_in, mutation: Mutations::SignIn
    field :update_user, mutation: Mutations::UpdateUser
    field :delete_user, mutation: Mutations::DeleteUser

    field :create_video, mutation: Mutations::CreateVideo
    field :update_video, mutation: Mutations::UpdateVideo
    field :delete_video, mutation: Mutations::DeleteVideo

    field :update_role, mutation: Mutations::UpdateRole
  end
end
