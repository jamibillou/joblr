require 'spec_helper'

describe FeedbackEmailMailer do

  describe "'footer_form' method" do

    let (:feedback_email) { FactoryGirl.create :feedback_email }
    let (:mail)           { FeedbackEmailMailer.footer_form(feedback_email) }

    it 'should send the email with the correct subject, author and recipient' do
      mail.subject.should == I18n.t('mailers.feedback_email.footer_form.subject', fullname: feedback_email.author.fullname)
      mail.to.should      == ['team@joblr.co']
      mail.from.should    == ['postman@joblr.co']
      mail.reply_to.should include feedback_email.author.email
    end

    it 'should send the email with the correct title' do
      mail.body.encoded.should include I18n.t('mailers.feedback_email.footer_form.title', fullname: feedback_email.author.fullname)
    end

    it 'should send the email with a feedback' do
      mail.body.encoded.should include "<b>#{I18n.t('mailers.feedback_email.footer_form.feedback')}</b>"
    end

    it 'should send the email with the correct content' do
      mail.body.encoded.should include I18n.t('mailers.feedback_email.footer_form.content_html', fullname: feedback_email.author.fullname, page: feedback_email.page)
    end

    it 'should send the email with the correct Contact button' do
      mail.body.encoded.should include "#{I18n.t('mailers.feedback_email.footer_form.button')}"
      mail.body.encoded.should include "mailto:#{feedback_email.author.email}?subject=RE: #{I18n.t('mailers.feedback_email.footer_form.subject', fullname: feedback_email.author.fullname)}".gsub!(' ','%20')
    end
  end
end