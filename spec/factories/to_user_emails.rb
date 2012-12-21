FactoryGirl.define do

  factory :to_user_email do
    author_fullname 'Joblr'
    author_email 'postman@joblr.co'
    text 'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores'
    association :recipient
  end
end
