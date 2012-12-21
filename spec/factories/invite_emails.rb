FactoryGirl.define do

  factory :invite_email do
    text 'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores'
    association :recipient
  end
end