module Mutations
  class DeleteVideo < BaseMutation
    argument :id, ID, required: true

    field :status, String, null: true
    field :errors, [String], null: false

    def resolve(id:)
      video = Video.find_or_initialize_by(id: id)

      authorize!(:destroy, video)

      if video.destroy
        { status: I18n.t('video_deleted'), errors: [] }
      else
        { errors: video.errors.full_messages }
      end
    end
  end
end
