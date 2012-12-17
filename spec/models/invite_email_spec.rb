# == Schema Information
#
# Table name: invite_emails
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  code       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sent       :boolean          default(FALSE)
#

require 'spec_helper'

describe InviteEmail do

  before :each do
    @user        = FactoryGirl.create :user
    @invite_email = FactoryGirl.create :invite_email, user: @user
  end

  describe 'user association' do

    it { @invite_email.should respond_to :user }

    it 'should have the right associated user' do
      @invite_email.user_id.should == @user.id
      @invite_email.user.should == @user
    end

    it 'should not destroy the associated user' do
      @invite_email.destroy
      User.find_by_id(@user.id).should_not be_nil
    end
  end

  describe 'validations' do

    before :all do
      @email = { :invalid => %w(invalid_email invalid@example invalid@user@example.com inv,alide@), :valid => %w(valid_email@example.com valid@example.co.kr vu@example.us) }
    end

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_format_of(:email).not_with(@email[:invalid][rand(@email[:invalid].size)]).with_message(I18n.t('activerecord.errors.messages.invalid')) }
    it { should validate_format_of(:email).with @email[:valid][rand(@email[:valid].size)] }
    it { should ensure_inclusion_of(:sent).in_array [true, false] }
  end
end
