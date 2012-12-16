FactoryGirl.define do

  factory :sharing_email do
    author_fullname 'Barack Obama'
    author_email 'b.obama@gov.us'
    recipient_fullname 'Jane Doe'
    recipient_email 'jane.doe@example.com'
    text 'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores'
    status 'declined'
    association :author
    association :profile
  end
end
