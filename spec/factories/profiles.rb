FactoryGirl.define do

  factory :profile do
    education 'Master of Business Administration'
    experience 5
    last_job 'Financial controller at Eneco'
    past_companies 'Nike, Telfort, KPMG'
    skill_1 'Financial control'
    skill_2 'Business analysis'
    skill_3 'Strategic decision making'
    skill_1_level 'Expert'
    skill_2_level 'Beginner'
    skill_3_level 'Intermediate'
    quality_1 'Drive'
    quality_2 'Work ethics'
    quality_3 'Punctuality'
    association :user
  end
end