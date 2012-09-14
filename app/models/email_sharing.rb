class EmailSharing < ActiveRecord::Base
  attr_accessible :author_email, :author_fullname, :author_id, :author, :profile_id, :profile, :recipient_email, :recipient_fullname, 
                  :text, :status

  belongs_to :author, class_name: 'User', foreign_key: :author_id
  belongs_to :profile

  validates :author_fullname,    length: { maximum: 100 }, 				      if: :author_required?, presence: true
  validates :author_email,       format: { with: Devise.email_regexp }, if:	:author_required?, presence: true
  validates :recipient_fullname, length: { maximum: 100 }, 								 	                   presence: true
  validates :recipient_email,    format: { with: Devise.email_regexp }, 				               presence: true
  validates :text, 				       length: { maximum: 140 }, 								                     presence: true
  validates :status,             inclusion: { :in => ['accepted', 'declined'] },               allow_nil: true

  def author_required?
  	author.nil?
  end

  def fullname
    author_required? ? author_fullname : author.fullname
  end

  def email
    if author_required?
      author_email
    elsif author.email.nil?
      "team@joblr.co"
    else
      author.email
    end
  end

  def user
    self.profile.user
  end 

  def user_email
    user.email.blank? ? "team@joblr.co" : profile.user.email
  end

  def own_sharing?
    author == user
  end
end

# == Schema Information
#
# Table name: email_sharings
#
#  id                 :integer         not null, primary key
#  profile_id         :integer
#  author_id          :integer
#  author_fullname    :string(255)
#  author_email       :string(255)
#  recipient_fullname :string(255)
#  recipient_email    :string(255)
#  text               :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  status             :string(255)
#

