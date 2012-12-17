require 'spec_helper'

describe InviteEmailMailer do

  describe "'notify_team' method" do

    let (:invite_email) { FactoryGirl.create :invite_email }
    let (:mail)        { InviteEmailMailer.notify_team(invite_email) }

    it 'should send the email with correct subject, author and recipient' do
      mail.subject.should == I18n.t('mailers.invite_email.notify_team.subject')
      mail.to.should      == ['team@joblr.co']
      mail.from.should    == ['postman@joblr.co']
    end

    it 'should have a title' do
      mail.body.encoded.should match(I18n.t('mailers.invite_email.notify_team.title'))
    end

    it 'should have a content' do
      mail.body.encoded.should match(Regexp.new(I18n.t('mailers.invite_email.notify_team.content_html', email: '.+')))
    end

    it 'should have a Send invite! button' do
      mail.body.encoded.should match(I18n.t('mailers.invite_email.notify_team.button'))
    end
  end

  describe "'send_code' method" do

    let (:invite_email) { FactoryGirl.create :invite_email }
    let (:mail)        { InviteEmailMailer.send_code(invite_email) }

    it 'should send the email with correct subject, author and recipient' do
      mail.subject.should == I18n.t('mailers.invite_email.send_code.subject')
      mail.to.should      == [invite_email.email]
      mail.from.should    == ['postman@joblr.co']
    end

    it 'should have a title' do
      mail.body.encoded.should match(I18n.t('mailers.invite_email.send_code.title'))
    end

    it 'should have a content with the right link' do
      mail.body.encoded.should match(Regexp.new(I18n.t('mailers.invite_email.send_code.content_html', url: '.+')))
      mail.body.encoded.should match("http://joblr.co/invite_emails/#{invite_email.id}/edit")
    end

    it 'should have the correct invitation code' do
      mail.body.encoded.should match(invite_email.code)
    end

    it 'should have a Sign up! button' do
      mail.body.encoded.should match(I18n.t('mailers.invite_email.send_code.button'))
    end
  end
end