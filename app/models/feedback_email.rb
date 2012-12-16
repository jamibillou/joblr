class FeedbackEmail < UserEmail
  attr_accessible :page

  validates :page, presence: true
end
