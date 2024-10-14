require 'rails_helper'

RSpec.describe 'UpdateUserMutation', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:user, roles: [FactoryBot.create(:role, name: 'admin')]) }
  let(:admin_token) { Warden::JWTAuth::UserEncoder.new.call(admin, :user, nil).first }
  let(:user_token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }

  describe 'update user' do
    it 'update the user channel name by owner' do
      new_channel_name = 'New Channel Name'

      post '/graphql', params: { query: update_user_query(id: user.id, channel_name: new_channel_name) },
                       headers: { Authorization: "Bearer #{user_token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response['data']['updateUser']['user']['channelName']).to eq(new_channel_name)
      expect(json_response['data']['updateUser']['errors']).to be_empty
    end

    it 'update the user channel name by admin' do
      new_channel_name = 'New Channel Name'

      post '/graphql', params: { query: update_user_query(id: user.id, channel_name: new_channel_name) },
                       headers: { Authorization: "Bearer #{admin_token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response['data']['updateUser']['user']['channelName']).to eq(new_channel_name)
      expect(json_response['data']['updateUser']['errors']).to be_empty
    end

    it 'returns errors when user does not have permission to update' do
      post '/graphql', params: { query: update_user_query(id: admin.id, channel_name: 'Another Channel Name') },
                       headers: { Authorization: "Bearer #{user_token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response['errors'][0]['message']).to include('You have no access to this action')
    end

    it 'returns errors when user does not authorized' do
      post '/graphql', params: { query: update_user_query(id: admin.id, channel_name: 'Another Channel Name') }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response['errors'][0]['message']).to include('You have no access to this action')
    end
  end

  private

  def update_user_query(id:, channel_name:)
    <<~GQL
      mutation {
        updateUser(input: {
          id: #{id},
          channelName: "#{channel_name}"
        }) {
          user {
            id
            channelName
          }
          errors
        }
      }
    GQL
  end
end
