# == Schema Information
#
# Table name: emails
#
#  id                 :integer          not null, primary key
#  author_fullname    :string(255)
#  author_email       :string(255)
#  recipient_fullname :string(255)
#  recipient_email    :string(255)
#  cc                 :string(255)
#  bcc                :string(255)
#  subject            :string(255)
#  text               :string(255)
#  status             :string(255)
#  type               :string(255)
#  profile_id         :integer
#  author_id          :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class SharingEmail < Email
  attr_accessible :author_id, :author, :profile_id, :profile, :status

  belongs_to :author, class_name: 'User', foreign_key: :author_id
  belongs_to :profile

  validates :text,   length: { maximum: 140 }, 								                                 presence: true
  validates :status, inclusion: { :in => ['accepted', 'declined'] },                           allow_nil: true
end