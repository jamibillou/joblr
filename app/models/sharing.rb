class Sharing < ActiveRecord::Base

  attr_accessible :text, :author_id, :recipient_id

  belongs_to :author,    class_name: 'User', foreign_key: :author_id
  belongs_to :recipient, class_name: 'User', foreign_key: :recipient_id

  validates :author,                         presence: true
  validates :recipient,                      presence: true
  validates :text, length: { maximum: 140 }, presence: true
end

# == Schema Information
#
# Table name: sharings
#
#  id           :integer         not null, primary key
#  author_id    :integer
#  recipient_id :integer
#  text         :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

