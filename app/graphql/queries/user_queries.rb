module Queries
  module UserQueries
    extend ActiveSupport::Concern

    included do
      field :users, [Types::UserType], null: false
      field :user, Types::UserType, null: true do
        argument :id, GraphQL::Types::ID, required: true
      end
      field :my_profile, Types::UserType, null: true
      field :search_user, [Types::UserType], null: true do
        argument :field, GraphQL::Types::String, required: true
      end
    end

    def users
      User.order(created_at: :desc)
    end

    def user(id:)
      User.find_by(id: id)
    end

    def my_profile
      context[:current_user]
    end

    def search_user(field:)
      search_param = ActiveRecord::Base.sanitize_sql_like(field)
      @results = User.where(
        'email ILIKE :search or channel_name ILIKE :search',
        search: "%#{search_param}%"
      )
    end
  end
end
