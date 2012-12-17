FactoryGirl.define do

  factory :invite_email do
    email 'jdoe@example.com'
    association :user
  end
end