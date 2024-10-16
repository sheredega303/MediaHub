FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    channel_name { Faker::Internet.username(specifier: 5..50) }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
