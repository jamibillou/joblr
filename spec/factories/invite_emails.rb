FactoryGirl.define do

  factory :invite_email do
    recipient_email 'factory.recipient@example.com'
    text 'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores'
    association :recipient
  end
end