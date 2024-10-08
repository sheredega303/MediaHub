module Types
  class UserType < BaseObject
    field :id, ID, null: false
    field :email, String, null: false
  end
end
