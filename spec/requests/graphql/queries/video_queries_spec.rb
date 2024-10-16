require 'rails_helper'

RSpec.describe 'VideoQueries', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:video) { FactoryBot.create(:video, user: user) }
  let!(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }

  describe 'videos' do
    it 'returns a list of videos' do
      2.times { FactoryBot.create(:video, user: user) }

      post '/graphql', params: { query: videos_query }, headers: { Authorization: "Bearer #{token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'videos').size).to eq(3)
    end
  end

  describe 'video' do
    it 'returns a video by id' do
      post '/graphql', params: { query: video_query(video.id) }, headers: { Authorization: "Bearer #{token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'video', 'title')).to eq(video.title)
    end

    it 'returns null for non-existent video' do
      post '/graphql', params: { query: video_query(-1) }, headers: { Authorization: "Bearer #{token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'video')).to be_nil
    end
  end

  describe 'my_videos' do
    it 'returns the current user videos' do
      post '/graphql', params: { query: my_videos_query }, headers: { Authorization: "Bearer #{token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'myVideos').size).to eq(user.videos.count)
    end

    it 'returns null for un-authorization user' do
      post '/graphql', params: { query: my_videos_query }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'myVideos')).to be_nil
    end
  end

  describe 'search_video' do
    it 'returns videos matching search criteria' do
      FactoryBot.create(:video, user: user, title: 'FindVideo5')
      FactoryBot.create(:video, user: user, title: 'FindVideo151251')
      FactoryBot.create(:video, user: user, title: 'Asdamfindervideo')

      post '/graphql', params: { query: search_video_query('findvideo') }, headers: { Authorization: "Bearer #{token}" }

      json_response = response.parsed_body

      expect(response).to have_http_status(:success)
      expect(json_response.dig('data', 'searchVideo').size).to eq(2)
    end
  end

  private

  def videos_query
    <<~GQL
      query {
        videos {
          id
          title
          description
          ageRating
          fileUrl
        }
      }
    GQL
  end

  def video_query(id)
    <<~GQL
      query {
        video(id: #{id}) {
          id
          title
          description
          ageRating
          fileUrl
        }
      }
    GQL
  end

  def my_videos_query
    <<~GQL
      query {
        myVideos {
          id
          title
          description
          ageRating
          fileUrl
        }
      }
    GQL
  end

  def search_video_query(field)
    <<~GQL
      query {
        searchVideo(field: "#{field}") {
          id
          title
          description
          ageRating
          fileUrl
        }
      }
    GQL
  end
end
