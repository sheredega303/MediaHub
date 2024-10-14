module Types
  class UserType < BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :channel_name, String
    field :roles, [String], null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def roles
      object.roles.pluck(:name)
    end
  end
end
