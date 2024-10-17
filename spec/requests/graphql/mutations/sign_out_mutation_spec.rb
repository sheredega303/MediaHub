require 'rails_helper'

RSpec.describe 'SignOutMutation', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let(:user_token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }

  describe 'user sign out' do
    it 'sign out successful' do
      post '/graphql', params: { query: sign_out_query },
                       headers: { Authorization: "Bearer #{user_token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'signOut', 'status')).to include(I18n.t('sign_out'))
      expect(json_response.dig('data', 'signOut', 'errors')).to be_empty
    end

    it 'user nog logged in' do
      post '/graphql', params: { query: sign_out_query }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'signOut', 'status')).to be_nil
      expect(json_response.dig('data', 'signOut', 'errors')).to include(I18n.t('sign_out_error'))
    end
  end

  private

  def sign_out_query
    <<~GQL
      mutation {
        signOut(input: {})
        {
          status
          errors
        }
      }
    GQL
  end
end
