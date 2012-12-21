FactoryGirl.define do

  factory :user, aliases: [:author, :recipient] do
    fullname 'John Doe'
    username 'j_doe'
    password 'pouetpouet38'
    email 'j.doe@example.com'
    city 'Amsterdam'
    country 'Netherlands'
  end
end
