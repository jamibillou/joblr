require 'spec_helper'

describe Authentification do

  before :each do
    @user = FactoryGirl.create :user
    @auth    = FactoryGirl.create :authentification, user: @user
    @attr = { provider: 'twitter', uid: 'john_d', uname: 'John Doe' }
  end

  describe 'users associations' do

    it { @auth.should respond_to :user }

    it 'should have the right associated user' do
      @auth.user_id.should == @user.id
      @auth.user.should    == @user
    end

    it 'should not destroy associated user' do
      @auth.destroy
      User.find_by_id(@user.id).should_not be_nil
    end
  end

  describe 'validations' do

    before :each do
      @url   = { valid: %(http://www.engaccino.com https://engaccino.com https://dom.engaccino.com http://franck.engaccino.com http://www.engaccino.co.uk https://dom.engaccino.com.hk http://engaccino.me http://www.engaccino.ly http://fr.engaccino/users/1/edit),
                 invalid: %w(invalid_url engaccino.com pouetpouetpouet http:www.engaccino.com http//engaccino.com http/ccino.co htp://ccino.me http:/www.engaccino.com) }
    end

    it { should validate_presence_of :user }
    it { should validate_presence_of :provider }
    it { should validate_presence_of :uid }
    it { should validate_format_of(:url).not_with(@url[:invalid]).with_message(I18n.t('activerecord.errors.messages.url_format')) }
    it { should validate_format_of(:url).with @url[:valid] }
  end
end

# == Schema Information
#
# Table name: authentifications
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  provider   :string(255)
#  uid        :string(255)
#  uname      :string(255)
#  uemail     :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  url        :string(255)
#  upic       :string(255)
#  utoken     :string(255)
#  usecret    :string(255)
#

