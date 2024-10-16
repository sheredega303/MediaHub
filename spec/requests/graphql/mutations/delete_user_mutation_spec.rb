require 'rails_helper'

RSpec.describe 'DeleteUserMutation', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:user, roles: [FactoryBot.create(:role, name: 'admin')]) }
  let(:admin_token) { Warden::JWTAuth::UserEncoder.new.call(admin, :user, nil).first }
  let(:user_token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }

  describe 'delete user' do
    it 'delete user by himself' do
      post '/graphql', params: { query: delete_user_query(user.id) }, headers: { Authorization: "Bearer #{user_token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'deleteUser', 'status')).to eq(I18n.t('user_deleted'))
      expect(json_response.dig('data', 'deleteUser', 'errors')).to be_empty
    end

    it 'delete user by admin' do
      post '/graphql', params: { query: delete_user_query(user.id) },
                       headers: { Authorization: "Bearer #{admin_token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'deleteUser', 'status')).to eq(I18n.t('user_deleted'))
      expect(json_response.dig('data', 'deleteUser', 'errors')).to be_empty
    end

    it 'returns a not permission error' do
      post '/graphql', params: { query: delete_user_query(admin.id) },
                       headers: { Authorization: "Bearer #{user_token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('errors', 0, 'message')).to include('You have no access to this action')
    end

    it 'returns a not authorized error' do
      post '/graphql', params: { query: delete_user_query(user.id) }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('errors', 0, 'message')).to include('You have no access to this action')
    end
  end

  private

  def delete_user_query(id)
    <<~GQL
      mutation {
        deleteUser(input: {id: #{id}}) {
          status
          errors
        }
      }
    GQL
  end
end
