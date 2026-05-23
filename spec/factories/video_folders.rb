FactoryBot.define do
  factory :video_folder do
    association :saved_video
    association :folder
  end
end
