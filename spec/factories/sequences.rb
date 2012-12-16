FactoryGirl.define do

  sequence :fullname do |n|
    "User #{n}"
  end

  sequence :username do |n|
    "user-#{n}"
  end

  sequence :email do |n|
    "user-#{n}@example.com"
  end
end