require 'rails_helper'

RSpec.describe 'UserQueries', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }

  describe 'users' do
    it 'returns a list of users' do
      5.times { FactoryBot.create(:user) }

      post '/graphql', params: { query: users_query }, headers: { Authorization: "Bearer #{token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'users').size).to eq(6)
    end
  end

  describe 'user' do
    it 'returns a user by id' do
      post '/graphql', params: { query: user_query(user.id) }, headers: { Authorization: "Bearer #{token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'user', 'email')).to eq(user.email)
    end

    it 'returns null for non-existent user' do
      post '/graphql', params: { query: user_query(-1) }, headers: { Authorization: "Bearer #{token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'user')).to be_nil
    end
  end

  describe 'my_profile' do
    it 'returns the current user profile' do
      post '/graphql', params: { query: my_profile_query }, headers: { Authorization: "Bearer #{token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'myProfile', 'email')).to eq(user.email)
      expect(json_response.dig('data', 'myProfile', 'channelName')).to eq(user.channel_name)
    end

    it 'returns null for un-authorization user' do
      post '/graphql', params: { query: my_profile_query }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'myProfile')).to be_nil
    end
  end

  describe 'search_user' do
    it 'returns users matching search criteria' do
      FactoryBot.create(:user, email: 'test_user1@example.com')
      FactoryBot.create(:user, email: 'test_user2@example.com')
      FactoryBot.create(:user, email: 'sample@example.com')

      post '/graphql', params: { query: search_user_query('test_user') }, headers: { Authorization: "Bearer #{token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'searchUser').size).to eq(2)
    end
  end

  private

  def users_query
    <<~GQL
      query {
        users {
          id
          email
          channelName
          roles
        }
      }
    GQL
  end

  def user_query(id)
    <<~GQL
      query {
        user(id: #{id}) {
          id
          email
          channelName
          roles
        }
      }
    GQL
  end

  def my_profile_query
    <<~GQL
      query {
        myProfile {
          id
          email
          channelName
          roles
        }
      }
    GQL
  end

  def search_user_query(field)
    <<~GQL
      query {
        searchUser(field: "#{field}") {
          id
          email
          channelName
          roles
        }
      }
    GQL
  end
end
