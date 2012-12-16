FactoryGirl.define do

  factory :user, aliases: [:author] do
    fullname 'John Doe'
    username 'j_doe'
    password 'pouetpouet38'
    email 'j.doe@example.com'
  end
end
