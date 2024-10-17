module Mutations
  class SignOut < BaseMutation
    field :status, String, null: true
    field :errors, [String], null: false

    def resolve
      if context[:current_user]
        JwtDenylist.create(jti: context[:token], exp: 1.day.from_now)
        { status: I18n.t('sign_out'), errors: [] }
      else
        { errors: [I18n.t('sign_out_error')] }
      end
    end
  end
end
