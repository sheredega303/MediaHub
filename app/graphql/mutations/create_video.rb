module Mutations
  class CreateVideo < BaseMutation
    argument :title, String, required: true
    argument :description, String, required: true
    argument :age_rating, String, required: true
    argument :file, ApolloUploadServer::Upload, required: true

    field :video, Types::VideoType, null: true
    field :errors, [String], null: false

    def resolve(title:, description:, age_rating:, file:)
      video = Video.new(title: title, description: description, age_rating: age_rating, user: context[:current_user])
      video.file.attach(io: file, filename: file.original_filename, content_type: file.content_type)
      if video.save
        { video: video, errors: [] }
      else
        { video: nil, errors: video.errors.full_messages }
      end
    end
  end
end
