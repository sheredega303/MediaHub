module Types
  class UserType < BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :channel_name, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
