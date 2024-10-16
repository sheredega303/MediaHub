require 'rails_helper'

RSpec.describe 'UpdateVideoMutation', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:manager) { FactoryBot.create(:user, roles: [FactoryBot.create(:role, name: 'manager')]) }
  let!(:admin) { FactoryBot.create(:user, roles: [FactoryBot.create(:role, name: 'admin')]) }

  let!(:video) { FactoryBot.create(:video, user: user) }
  let!(:another_video) { FactoryBot.create(:video, user: manager) }
  let!(:user_token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
  let!(:manager_token) { Warden::JWTAuth::UserEncoder.new.call(manager, :user, nil).first }
  let!(:admin_token) { Warden::JWTAuth::UserEncoder.new.call(admin, :user, nil).first }

  describe 'update video' do
    it 'updates video by owner' do
      post '/graphql', params: {
        query: update_video_query(id: video.id, title: 'Updated Title',
                                  description: 'Updated Description', age_rating: 'PG-13')
      }, headers: { Authorization: "Bearer #{user_token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'updateVideo', 'video', 'title')).to eq('Updated Title')
      expect(json_response.dig('data', 'updateVideo', 'errors')).to be_empty
    end

    it 'updates video by manager' do
      post '/graphql', params: {
        query: update_video_query(id: video.id, title: 'Updated Title',
                                  description: 'Updated Description', age_rating: 'PG-13')
      }, headers: { Authorization: "Bearer #{manager_token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'updateVideo', 'video', 'title')).to eq('Updated Title')
      expect(json_response.dig('data', 'updateVideo', 'errors')).to be_empty
    end

    it 'updates video by admin' do
      post '/graphql', params: {
        query: update_video_query(id: video.id, title: 'Updated Title',
                                  description: 'Updated Description', age_rating: 'PG-13')
      }, headers: { Authorization: "Bearer #{admin_token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'updateVideo', 'video', 'title')).to eq('Updated Title')
      expect(json_response.dig('data', 'updateVideo', 'errors')).to be_empty
    end

    it 'returns error when user is not authorized' do
      post '/graphql', params: {
        query: update_video_query(id: video.id, title: 'Updated Title',
                                  description: 'Updated Description', age_rating: 'PG-13')
      }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('errors', 0, 'message')).to include('You have no access to this action')
    end

    it 'returns error when user has no permission to update video' do
      post '/graphql', params: {
        query: update_video_query(id: another_video.id, title: 'Updated Title',
                                  description: 'Updated Description', age_rating: 'PG-13')
      }, headers: { Authorization: "Bearer #{user_token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('errors', 0, 'message')).to include('You have no access to this action')
    end

    it 'returns errors with invalid arguments' do
      post '/graphql', params: {
        query: update_video_query(id: video.id, title: '', description: '', age_rating: '')
      }, headers: { Authorization: "Bearer #{user_token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'updateVideo', 'video')).to be_nil
      expect(json_response.dig('data', 'updateVideo', 'errors')).not_to be_empty
    end

    it 'returns error when video not found' do
      post '/graphql', params: {
        query: update_video_query(id: 'nonexistent-id', title: 'Updated Title',
                                  description: 'Updated Description', age_rating: 'PG-13')
      }, headers: { Authorization: "Bearer #{user_token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('errors', 0, 'message')).to include('You have no access to this action')
    end
  end

  private

  def update_video_query(id:, title:, description:, age_rating:)
    <<~GQL
      mutation {
        updateVideo(input: {
          id: "#{id}",
          title: "#{title}",
          description: "#{description}",
          ageRating: "#{age_rating}"
        }) {
          video {
            id
            title
            description
            ageRating
          }
          errors
        }
      }
    GQL
  end
end
