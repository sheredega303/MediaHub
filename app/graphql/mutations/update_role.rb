module Mutations
  class UpdateRole < BaseMutation
    argument :id, ID, required: true
    argument :present, Boolean, required: true
    argument :role, String, required: true

    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    def resolve(id:, present:, role:)
      user = User.find_by(id: id)

      authorize! :update_role, user

      if present ? user.add_role(role) : user.remove_role(role)
        { user: user, errors: [] }
      else
        { user: user, errors: user.errors.full_messages }
      end
    end
  end
end
