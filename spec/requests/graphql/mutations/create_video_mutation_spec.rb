require 'rails_helper'

RSpec.describe 'CreateVideoMutation', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:user_token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }

  describe 'create video' do
    it 'create a new video' do
      file = fixture_file_upload('spec/fixtures/files/test_video.mp4', 'video/mp4')

      post '/graphql', params: {
        operations: {
          query: create_video_query,
          variables: {
            title: 'Sample Video',
            description: 'Description',
            ageRating: 'PG',
            file: nil
          }
        }.to_json,
        map: {
          '0' => ['variables.file']
        }.to_json,
        '0' => file
      }, headers: { Authorization: "Bearer #{user_token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'createVideo', 'video', 'title')).to eq('Sample Video')
      expect(json_response.dig('data', 'createVideo', 'errors')).to be_empty
    end

    it 'returns error when user is not authorized' do
      file = fixture_file_upload('spec/fixtures/files/test_video.mp4', 'video/mp4')

      post '/graphql', params: {
        operations: {
          query: create_video_query,
          variables: {
            title: 'Sample Video',
            description: 'Description',
            ageRating: 'PG',
            file: nil
          }
        }.to_json,
        map: {
          '0' => ['variables.file']
        }.to_json,
        '0' => file
      }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'createVideo', 'video')).to be_nil
      expect(json_response.dig('data', 'createVideo', 'errors')).not_to be_empty
    end

    it 'returns errors when invalid arguments' do
      post '/graphql', params: {
        operations: {
          query: create_video_query,
          variables: {
            title: 'Sample Video',
            description: 'Description',
            ageRating: 'PG',
            file: nil
          }
        }.to_json,
        map: {
          '0' => ['variables.file']
        }.to_json,
        '0' => nil
      }, headers: { Authorization: "Bearer #{user_token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('errors', 0, 'message')).not_to be_empty
    end
  end

  private

  def create_video_query
    <<~GQL
      mutation createVideo($title: String!, $description: String!, $ageRating: String!, $file: Upload!) {
        createVideo(input: { title: $title, description: $description, ageRating: $ageRating, file: $file }) {
          video {
            id
            title
            description
            ageRating
            fileUrl
          }
          errors
        }
      }
    GQL
  end
end
