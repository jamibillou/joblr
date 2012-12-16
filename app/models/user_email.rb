class UserEmail < Email
  attr_accessible :author_id, :author

  belongs_to :author, class_name: 'User', foreign_key: :author_id
end
