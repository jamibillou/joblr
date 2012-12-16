FactoryGirl.define do

  factory :user_email do
    author_fullname 'Factory Author'
    author_email 'factory.author@example.com'
    recipient_fullname 'Factory Recipient'
    recipient_email 'factory.recipient@example.com'
    text 'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores'
    association :author
  end
end
