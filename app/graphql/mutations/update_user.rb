module Mutations
  class UpdateUser < BaseMutation
    argument :id, ID, required: true
    argument :channel_name, String, required: true

    field :user, Types::UserType, null: true
    field :errors, [String], null: false

    def resolve(id:, channel_name:)
      user = User.find_or_initialize_by(id: id)

      authorize! :update, user

      if user.update(channel_name: channel_name)
        { user: user, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    end
  end
end
