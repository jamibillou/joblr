FactoryGirl.define do

  factory :user do
    fullname 'John Doe'
    username 'j_doe'
    password 'pouetpouet38'
    email 'j.doe@example.com'
  end

  factory :authentification do
    provider 'twitter'
    uid 'john_d'
    uname 'John Doe'
    association :user
  end

  factory :profile do
    headline 'fulltime'
    education 'Master of Business Administration'
    experience '5 yrs'
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
    text "I'm extremely brilliant, motivated and genuinely modest."
    association :user
  end

  factory :email_sharing do
    text 'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores'
    author_fullname 'Barack Obama'
    author_email 'b.obama@gov.us'
    recipient_fullname 'Jane Doe'
    recipient_email 'jane.doe@example.com'
    status 'declined'
    reason 'Your profile does not match enough to our job'
    association :author
    association :profile
  end

  factory :beta_invite do
    email 'jdoe@example.com'
    association :user
  end

  sequence :fullname do |n|
    "User #{n}"
  end

  sequence :username do |n|
    "user-#{n}"
  end

  sequence :email do |n|
    "user-#{n}@example.com"
  end
end