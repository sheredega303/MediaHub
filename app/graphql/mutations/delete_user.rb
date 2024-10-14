module Mutations
  class DeleteUser < BaseMutation
    argument :id, ID, required: true

    field :status, String, null: true
    field :errors, [String], null: false

    def resolve(id:)
      user = User.find_by(id: id)
      if user.destroy
        { status: I18n.t('user_deleted'), errors: [] }
      else
        { errors: user.errors.full_messages }
      end
    end
  end
end
