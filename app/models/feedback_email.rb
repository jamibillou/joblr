class FeedbackEmail < UserEmail
  attr_accessible :page

  validates :page, presence: true

  before_validation :fill_in_recipient

  private

    def fill_in_recipient
      self.recipient_fullname = 'Joblr team'
      self.recipient_email = 'team@joblr.co'
    end
end
