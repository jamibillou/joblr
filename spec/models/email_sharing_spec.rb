require 'spec_helper'

describe EmailSharing do

	before :each do
		@profile   = FactoryGirl.create :profile
		@author    = FactoryGirl.create :user
		@sharing_registered   = FactoryGirl.create :sharing, profile: @profile, author: @author
		@sharing_public				= FactoryGirl.public :sharing, profile: @profile, author: nil
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
#

