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
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'spec_helper'

describe Email do

  before :each do
    @email = FactoryGirl.create :email, author_email: FactoryGirl.generate(:email), recipient_email: FactoryGirl.generate(:email), cc: '', bcc: ''
  end

  describe 'Validations' do

    before :all do
      @emails = { :invalid => %w(invalid_email invalid@example invalid@user@example.com inv,alide@), :valid => %w(valid_email@example.com valid@example.co.kr vu@example.us) }
    end

    it { @email.should validate_presence_of :author_fullname }
    it { @email.should ensure_length_of(:author_fullname).is_at_most 100 }
    it { @email.should validate_presence_of :author_email }
    it { should validate_format_of(:author_email).not_with(@emails[:invalid][rand(@emails[:invalid].size)]).with_message(I18n.t('activerecord.errors.messages.invalid')) }
    it { should validate_format_of(:author_email).with @emails[:valid][rand(@emails[:valid].size)] }
    it { should validate_presence_of :recipient_fullname }
    it { should ensure_length_of(:recipient_fullname).is_at_most 100 }
    it { should allow_value('').for(:cc) }
    it { should validate_format_of(:cc).not_with(@emails[:invalid][rand(@emails[:invalid].size)]).with_message(I18n.t('activerecord.errors.messages.invalid')) }
    it { should validate_format_of(:cc).with @emails[:valid][rand(@emails[:valid].size)] }
    it { should allow_value('').for(:bcc) }
    it { should validate_format_of(:bcc).not_with(@emails[:invalid][rand(@emails[:invalid].size)]).with_message(I18n.t('activerecord.errors.messages.invalid')) }
    it { should validate_format_of(:bcc).with @emails[:valid][rand(@emails[:valid].size)] }
    it { should validate_presence_of :recipient_email }
    it { should validate_format_of(:recipient_email).not_with(@emails[:invalid][rand(@emails[:invalid].size)]).with_message(I18n.t('activerecord.errors.messages.invalid')) }
    it { should validate_format_of(:recipient_email).with @emails[:valid][rand(@emails[:valid].size)] }
    it { should ensure_length_of(:subject).is_at_most 150 }
    it { should validate_presence_of :subject }
    it { should validate_presence_of :text }
  end
end
