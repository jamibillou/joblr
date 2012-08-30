class EmailSharing < ActiveRecord::Base
  attr_accessible :author_email, :author_fullname, :author_id, :profile_id, :recipient_email, :recipient_fullname, :text
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
#

