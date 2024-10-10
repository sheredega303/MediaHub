module Types
  class VideoType < BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :description, String
    field :age_rating, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :file_url, String, null: false

    def file_url
      object.file.url
    end
  end
end
