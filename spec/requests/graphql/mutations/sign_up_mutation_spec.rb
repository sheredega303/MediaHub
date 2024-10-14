require 'rails_helper'

RSpec.describe 'SignUpMutation', type: :request do
  describe 'user registration' do
    let(:valid_attributes) do
      {
        email: 'user@example.com',
        password: 'password123',
        password_confirmation: 'password123',
        channel_name: 'Test Channel'
      }
    end

    let(:invalid_attributes) do
      {
        email: 'user@example.com',
        password: 'password123',
        password_confirmation: 'wrongpassword',
        channel_name: 'Test Channel'
      }
    end

    it 'register new user' do
      post '/graphql', params: { query: sign_up_query(valid_attributes) }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response['data']['signUp']['user']['email']).to eq(valid_attributes[:email])
      expect(json_response['data']['signUp']['token']).to be_present
      expect(json_response['data']['signUp']['errors']).to be_empty
    end

    it 'does not register a user with invalid attributes' do
      post '/graphql', params: { query: sign_up_query(invalid_attributes) }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response['data']['signUp']['user']).to be_nil
      expect(json_response['data']['signUp']['token']).to be_nil
      expect(json_response['data']['signUp']['errors']).to include("Password confirmation doesn't match Password")
    end
  end

  private

  def sign_up_query(attributes)
    <<~GQL
      mutation {
        signUp(input: {
          email: "#{attributes[:email]}",
          password: "#{attributes[:password]}",
          passwordConfirmation: "#{attributes[:password_confirmation]}",
          channelName: "#{attributes[:channel_name]}"
        }) {
          user {
            id
            email
            channelName
          }
          token
          errors
        }
      }
    GQL
  end
end
