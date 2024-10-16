module Types
  class VideoType < BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :description, String
    field :age_rating, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :file_url, String, null: false
    field :author, Types::UserType, null: false

    def file_url
      if Rails.env.test?
        Rails.application.routes.url_helpers.rails_blob_path(object.file, only_path: true)
      else
        object.file.url
      end
    end

    def author
      object.user
    end
  end
end
