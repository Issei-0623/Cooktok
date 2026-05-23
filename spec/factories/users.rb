FactoryBot.define do
  factory :user do
    email    { Faker::Internet.unique.email }
    password { "password123" }
    password_confirmation { "password123" }
    nickname { Faker::Name.name.slice(0, 30) }
  end
end
