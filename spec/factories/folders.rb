FactoryBot.define do
  factory :folder do
    association :user
    name { Faker::Lorem.unique.word }
  end
end
