# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :email_sharing do
    profile_id 1
    author_id 1
    author_fullname "MyString"
    author_email "MyString"
    recipient_fullname "MyString"
    recipient_email "MyString"
  end
end
