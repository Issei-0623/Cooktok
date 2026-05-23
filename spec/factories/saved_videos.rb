FactoryBot.define do
  factory :saved_video do
    association :user
    title        { Faker::Lorem.sentence }
    url          { "https://www.youtube.com/embed/#{Faker::Alphanumeric.alphanumeric(number: 11)}" }
    nickname     { Faker::Name.name }
    username     { Faker::Internet.username }
    needs_sorting { true }
  end
end
