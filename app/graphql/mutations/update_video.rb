module Mutations
  class UpdateVideo < BaseMutation
    argument :id, ID, required: true
    argument :title, String, required: true
    argument :description, String, required: true
    argument :age_rating, String, required: true

    field :video, Types::VideoType, null: true
    field :errors, [String], null: false

    def resolve(id:, title:, description:, age_rating:)
      video = Video.find_or_initialize_by(id: id)
      if video.update(title: title, description: description, age_rating: age_rating)
        { video: video, errors: [] }
      else
        { video: nil, errors: video.errors.full_messages }
      end
    end
  end
end
