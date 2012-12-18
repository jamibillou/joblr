FactoryGirl.define do

  factory :from_user_email do
    recipient_fullname 'Factory Recipient'
    recipient_email 'factory.recipient@example.com'
    text 'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores'
    association :author
  end
end
