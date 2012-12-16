FactoryGirl.define do

  factory :beta_invite do
    email 'jdoe@example.com'
    association :user
  end
end