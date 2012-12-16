# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :email do
    author_fullname "MyString"
    author_email "MyString"
    recipient_fullname "MyString"
    recipient_email "MyString"
    cc "MyString"
    bcc "MyString"
    subject "MyString"
    text "MyString"
  end
end
