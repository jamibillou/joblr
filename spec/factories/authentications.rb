FactoryGirl.define do

  factory :authentication do
    provider 'twitter'
    uid 'john_d'
    uname 'John Doe'
    association :user
  end
end
