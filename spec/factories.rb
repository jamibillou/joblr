FactoryGirl.define do

  factory :user do
    fullname 'John Doe' 
    email 'j.doe@example.com'
  end

  factory :profile do
    education 'Master of Business Administration'
    experience '5 yrs'
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