require 'rails_helper'

RSpec.describe 'SignInMutation', type: :request do
  let!(:user) { FactoryBot.create(:user) }

  describe 'user sign in' do
    it 'signs in a user with valid credentials' do
      post '/graphql', params: { query: sign_in_query(email: user.email, password: 'password') }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response['data']['signIn']['user']['email']).to eq(user.email)
      expect(json_response['data']['signIn']['token']).to be_present
      expect(json_response['data']['signIn']['errors']).to be_empty
    end

    it 'does not sign in a user with invalid email' do
      post '/graphql', params: { query: sign_in_query(email: 'invalid@example.com', password: 'password123') }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response['data']['signIn']['user']).to be_nil
      expect(json_response['data']['signIn']['token']).to be_nil
      expect(json_response['data']['signIn']['errors']).to include(I18n.t('sign_in_error'))
    end

    it 'does not sign in a user with invalid password' do
      post '/graphql', params: { query: sign_in_query(email: user.email, password: 'wrongpassword') }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response['data']['signIn']['user']).to be_nil
      expect(json_response['data']['signIn']['token']).to be_nil
      expect(json_response['data']['signIn']['errors']).to include(I18n.t('sign_in_error'))
    end
  end

  private

  def sign_in_query(email:, password:)
    <<~GQL
      mutation {
        signIn(input: {
          email: "#{email}",
          password: "#{password}"
        })
        {
          user {
            id
            email
          }
          token
          errors
        }
      }
    GQL
  end
end
