require 'rails_helper'

RSpec.describe 'UpdateRoleMutation', type: :request do
  let!(:manager_role) { FactoryBot.create(:role, name: 'manager') }
  let!(:user) { FactoryBot.create(:user) }
  let!(:admin) { FactoryBot.create(:user, roles: [FactoryBot.create(:role, name: 'admin')]) }
  let!(:manager) { FactoryBot.create(:user, roles: [manager_role]) }

  let(:admin_token) { Warden::JWTAuth::UserEncoder.new.call(admin, :user, nil).first }
  let(:user_token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }

  describe 'update role' do
    it 'add a role to another user' do
      post '/graphql', params: { query: update_role_query(user.id, true, 'manager') },
                       headers: { Authorization: "Bearer #{admin_token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'updateRole', 'user', 'id')).to eq(user.id.to_s)
      expect(json_response.dig('data', 'updateRole', 'errors')).to be_empty
    end

    it 'remove a role from another user' do
      post '/graphql', params: { query: update_role_query(manager.id, false, 'manager') },
                       headers: { Authorization: "Bearer #{admin_token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'updateRole', 'user', 'id')).to eq(manager.id.to_s)
      expect(json_response.dig('data', 'updateRole', 'errors')).to be_empty
    end

    it 'returns a permission error when trying to update another user role' do
      post '/graphql', params: { query: update_role_query(user.id, true, 'manager') },
                       headers: { Authorization: "Bearer #{user_token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('errors', 0, 'message')).to include('You have no access to this action')
    end
  end

  private

  def update_role_query(id, present, role)
    <<~GQL
      mutation {
        updateRole(input: {id: #{id}, present: #{present}, role: "#{role}"}) {
          user {
            id
            roles
          }
          errors
        }
      }
    GQL
  end
end
