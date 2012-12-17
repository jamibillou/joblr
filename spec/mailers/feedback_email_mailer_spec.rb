require 'spec_helper'

describe FeedbackEmailMailer do

  describe "'footer_form' method" do

    let (:feedback_email) { FactoryGirl.create :feedback_email }
    let (:mail)           { FeedbackEmailMailer.footer_form(feedback_email) }

    it 'should send the email with correct subject, author and recipient' do
      mail.subject.should == I18n.t('mailers.feedback_email.footer_form.subject')
      mail.to.should      == ['team@joblr.co']
      mail.from.should    == ['postman@joblr.co']
    end

    it 'should have a title' do
      mail.body.encoded.should match(I18n.t('mailers.feedback_email.footer_form.title'))
    end

    it 'should have a feedback' do
      mail.body.encoded.should match(I18n.t('mailers.feedback_email.footer_form.feedback'))
    end

    it 'should have a content' do
      mail.body.encoded.should match(Regexp.new(I18n.t('mailers.feedback_email.footer_form.content_html')))
    end

    it 'should have a Contact button' do
      mail.body.encoded.should match(I18n.t('mailers.feedback_email.footer_form.button'))
    end
  end
end