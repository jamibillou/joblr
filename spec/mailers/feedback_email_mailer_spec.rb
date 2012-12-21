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

    it 'should send the email with the correct header' do
      mail.body.encoded.should include I18n.t('mailers.feedback_email.footer_form.header', fullname: feedback_email.author.fullname, page: feedback_email.page)
    end

    it 'should send the email with the correct text' do
      mail.body.encoded.should include feedback_email.text
    end

    it 'should send the email with a picture' do
      mail.body.encoded.should include 'alt="profile picture"'.html_safe
    end

    it 'should send the email with the correct fullname' do
      mail.body.encoded.should include feedback_email.author.fullname
    end

    it 'should send the email with the correct location' do
      mail.body.encoded.should include "#{feedback_email.author.city}, #{feedback_email.author.country}"
    end

    it 'should send the email with the correct email address' do
      mail.body.encoded.should include feedback_email.author.email
    end

    it 'should send the email with the correct Contact button' do
      mail.body.encoded.should include "#{I18n.t('mailers.feedback_email.footer_form.button')}"
      mail.body.encoded.should include "mailto:#{feedback_email.author.email}?subject=#{I18n.t('mailers.re')} #{I18n.t('mailers.feedback_email.footer_form.subject', fullname: feedback_email.author.fullname)}".gsub!(' ','%20')
    end
  end
end
