FactoryBot.define do
  factory :video do
    association :user

    title { Faker::Movie.title }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    age_rating { %w[G PG PG-13 R NC-17].sample }
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_video.mp4'), 'video/mp4') }
  end
end
