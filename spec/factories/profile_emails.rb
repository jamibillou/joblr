FactoryGirl.define do

  factory :profile_email do
    author_fullname 'Factory Author'
    author_email 'factory.author@example.com'
    recipient_fullname 'Factory Recipient'
    recipient_email 'factory.recipient@example.com'
    text "Sed ut perspiciatis,<br /><br />Unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem.<br />Quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt.<br />Ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae.<br /><br />Consequatur, vel illum qui dolorem eum fugiat quo voluptas<br />Nulla pariatur?"
    status 'declined'
    association :author
    association :profile
  end
end
