FactoryGirl.define do

  factory :feedback_email do
    text 'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores.'
    page '/users/edit'
    association :author
  end
end
