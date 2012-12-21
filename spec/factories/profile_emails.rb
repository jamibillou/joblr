FactoryGirl.define do

  factory :profile_email do
    recipient_fullname 'Factory Recipient'
    recipient_email 'factory.recipient@example.com'
    text 'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores'
    status 'declined'
    association :author
    association :profile
  end
end
