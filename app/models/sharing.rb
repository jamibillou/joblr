class Sharing < ActiveRecord::Base

  attr_accessible :company, :email, :fullname, :role, :text ,:user_id

  belongs_to :user

  validates :user, 												presence: true
  validates :email,    format: { with:   Devise.email_regexp }, presence: true
  validates :company,  length: { maximum: 100 }
  validates :fullname, length: { maximum: 100 }
  validates :role,     length: { maximum: 50 }
  validates :text,     length: { maximum: 140 },				presence: true	

end

# == Schema Information
#
# Table name: sharings
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  email      :string(255)
#  fullname   :string(255)
#  company    :string(255)
#  role       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  text       :string(255)
#

