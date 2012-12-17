require 'spec_helper'

describe InviteEmailMailer do

  describe "'notify_team' method" do

    let (:invite_email) { FactoryGirl.create :invite_email }
    let (:mail)        { InviteEmailMailer.notify_team(invite_email) }

    it 'should send the email with the correct subject, author and recipient' do
      mail.subject.should == I18n.t('mailers.invite_email.notify_team.subject')
      mail.to.should   include 'team@joblr.co'
      mail.from.should include 'postman@joblr.co'
    end

    it 'should send the email with the correct title' do
      mail.body.encoded.should include I18n.t('mailers.invite_email.notify_team.title')
    end

    it 'should send the email with the correct content' do
      mail.body.encoded.should match(Regexp.new(I18n.t('mailers.invite_email.notify_team.content_html', email: '.+')))
    end

    it 'should send the email with a Send invite! button' do
      mail.body.encoded.should include I18n.t('mailers.invite_email.notify_team.button')
    end
  end

  describe "'send_code' method" do

    let (:invite_email) { FactoryGirl.create :invite_email }
    let (:mail)        { InviteEmailMailer.send_code(invite_email) }

    it 'should send the email with the correct subject, author and recipient' do
      mail.subject.should == I18n.t('mailers.invite_email.send_code.subject')
      mail.to.should   include invite_email.recipient_email
      mail.from.should include 'postman@joblr.co'
    end

    it 'should send the email with the correct title' do
      mail.body.encoded.should match(I18n.t('mailers.invite_email.send_code.title'))
    end

    it 'should send the email with the correct content and link' do
      mail.body.encoded.should match(Regexp.new(I18n.t('mailers.invite_email.send_code.content_html', url: '.+')))
      mail.body.encoded.should include "http://joblr.co/invite_emails/#{invite_email.id}/edit"
    end

    it 'should send the email with the correct invitation code' do
      mail.body.encoded.should include invite_email.code
    end

    it 'should send the email with a Sign up! button' do
      mail.body.encoded.should include I18n.t('mailers.invite_email.send_code.button')
    end
  end
end