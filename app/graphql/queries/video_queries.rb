module Queries
  module VideoQueries
    extend ActiveSupport::Concern

    included do
      field :videos, [Types::VideoType], null: false
      field :video, Types::VideoType, null: true do
        argument :id, GraphQL::Types::ID, required: true
      end
      field :my_videos, [Types::VideoType], null: true
      field :search_video, [Types::VideoType], null: true do
        argument :field, GraphQL::Types::String, required: true
      end
    end

    def videos
      Video.order(created_at: :desc)
    end

    def video(id:)
      Video.find_by(id: id)
    end

    def my_videos
      context[:current_user]&.videos&.order(created_at: :desc)
    end

    def search_video(field:)
      search_param = ActiveRecord::Base.sanitize_sql_like(field)
      @results = Video.where(
        'title ILIKE :search or description ILIKE :search',
        search: "%#{search_param}%"
      )
    end
  end
end
