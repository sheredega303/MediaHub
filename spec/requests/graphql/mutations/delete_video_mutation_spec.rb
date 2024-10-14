require 'rails_helper'

RSpec.describe 'DeleteVideoMutation', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:manager) { FactoryBot.create(:user, roles: [FactoryBot.create(:role, name: 'manager')]) }
  let!(:admin) { FactoryBot.create(:user, roles: [FactoryBot.create(:role, name: 'admin')]) }

  let!(:video) { FactoryBot.create(:video, user: user) }
  let!(:another_video) { FactoryBot.create(:video, user: manager) }
  let!(:user_token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
  let!(:manager_token) { Warden::JWTAuth::UserEncoder.new.call(manager, :user, nil).first }
  let!(:admin_token) { Warden::JWTAuth::UserEncoder.new.call(admin, :user, nil).first }

  describe 'delete video' do
    it 'delete video by owner' do
      post '/graphql', params: {
        query: delete_video_query(id: video.id)
      }, headers: { Authorization: "Bearer #{user_token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response['data']['deleteVideo']['status']).to eq(I18n.t('video_deleted'))
      expect(json_response['data']['deleteVideo']['errors']).to be_empty
    end

    it 'delete video by admin' do
      post '/graphql', params: {
        query: delete_video_query(id: video.id)
      }, headers: { Authorization: "Bearer #{admin_token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response['data']['deleteVideo']['status']).to eq(I18n.t('video_deleted'))
      expect(json_response['data']['deleteVideo']['errors']).to be_empty
    end

    it 'delete video by manager' do
      post '/graphql', params: {
        query: delete_video_query(id: video.id)
      }, headers: { Authorization: "Bearer #{manager_token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response['data']['deleteVideo']['status']).to eq(I18n.t('video_deleted'))
      expect(json_response['data']['deleteVideo']['errors']).to be_empty
    end

    it 'returns error when user is not authorized' do
      post '/graphql', params: {
        query: delete_video_query(id: video.id)
      }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response['errors'][0]['message']).to include('You have no access to this action')
    end

    it 'returns error when user has not permission to update video' do
      post '/graphql', params: {
        query: delete_video_query(id: another_video.id)
      }, headers: { Authorization: "Bearer #{user_token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response['errors'][0]['message']).to include('You have no access to this action')
    end
  end

  private

  def delete_video_query(id:)
    <<~GQL
      mutation {
        deleteVideo(input: {
          id: "#{id}"
        }) {
          status
          errors
        }
      }
    GQL
  end
end
