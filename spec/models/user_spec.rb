require 'spec_helper'

describe User do

  before :each do
    @user = FactoryGirl.create :user
    @profile = FactoryGirl.create :profile, user: @user
  end

  describe 'profiles associations' do

    it { @user.should respond_to :profiles }

    it 'should destroy associated profiles' do
      @user.destroy
      Profile.find_by_id(@profile.id).should be_nil
    end
  end

  describe 'validations' do
    it { should ensure_length_of(:fullname).is_at_most 100 }
    it { should ensure_length_of(:city).is_at_most 50 }
    it { should ensure_length_of(:country).is_at_most 50 }
    it { should ensure_length_of(:role).is_at_most 100 }
    it { should ensure_length_of(:company).is_at_most 50 }
  end
end

## == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  fullname               :string(255)
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#

# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  fullname               :string(255)
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  city                   :string(255)
#  country                :string(255)
#  role                   :string(255)
#  company                :string(255)
#

