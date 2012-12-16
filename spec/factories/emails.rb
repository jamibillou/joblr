FactoryGirl.define do

  factory :email do
    author_fullname 'factory_author@example.com'
    author_email 'Factory Author'
    recipient_fullname 'Factory Recipient'
    recipient_email 'factory_recipient@example.com'
    cc ''
    bcc ''
    subject ''
    text 'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores'
  end
end
