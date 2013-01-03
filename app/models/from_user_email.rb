# == Schema Information
#
# Table name: emails
#
#  id                 :integer          not null, primary key
#  recipient_id       :integer
#  code               :string(255)
#  recipient_email    :string(255)
#  sent               :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  author_fullname    :string(255)
#  author_email       :string(255)
#  recipient_fullname :string(255)
#  cc                 :string(255)
#  bcc                :string(255)
#  reply_to           :string(255)
#  subject            :string(255)
#  status             :string(255)
#  type               :string(255)
#  page               :string(255)
#  text               :text
#  used               :boolean          default(FALSE)
#  profile_id         :integer
#  author_id          :integer
#

class FromUserEmail < Email
  attr_accessible :author_id, :author

  belongs_to :author, class_name: 'User', foreign_key: :author_id
end
