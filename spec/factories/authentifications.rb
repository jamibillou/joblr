FactoryGirl.define do

  factory :authentification do
    provider 'twitter'
    uid 'john_d'
    uname 'John Doe'
    association :user
  end
end
