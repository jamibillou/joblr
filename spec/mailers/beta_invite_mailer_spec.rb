require 'spec_helper'

describe BetaInviteMailer do

  describe "'notify_team' method" do

    let (:beta_invite) { FactoryGirl.create :beta_invite }
    let (:mail)        { BetaInviteMailer.notify_team(beta_invite) }

    it 'should send the email with correct subject, author and recipient' do
      mail.subject.should == I18n.t('mailers.beta_invite.notify_team.subject')
      mail.to.should      == ['team@joblr.co']
      mail.from.should    == ['postman@joblr.co']
    end

    it 'should have a title' do
      mail.body.encoded.should match(I18n.t('mailers.beta_invite.notify_team.title'))
    end

    it 'should have a content' do
      mail.body.encoded.should match(I18n.t('mailers.beta_invite.notify_team.content_html', email: beta_invite.email))
    end

    it 'should have link to the admin page' do
      mail.body.encoded.should match(Regexp.new(I18n.t('mailers.beta_invite.notify_team.go_to_url_html', url: '.+')))
      mail.body.encoded.should match('http://joblr.co/admin')
    end

    it 'should have a Go now! button' do
      mail.body.encoded.should match(I18n.t('mailers.beta_invite.notify_team.button'))
    end
  end

  describe "'send_code' method" do

    let (:beta_invite) { FactoryGirl.create :beta_invite }
    let (:mail)        { BetaInviteMailer.send_code(beta_invite) }

    it 'should send the email with correct subject, author and recipient' do
      mail.subject.should == I18n.t('mailers.beta_invite.send_code.subject')
      mail.to.should      == [beta_invite.email]
      mail.from.should    == ['postman@joblr.co']
    end

    it 'should have a title' do
      mail.body.encoded.should match(I18n.t('mailers.beta_invite.send_code.title'))
    end

    it 'should have a content with the right link' do
      mail.body.encoded.should match(Regexp.new(I18n.t('mailers.beta_invite.send_code.content_html', url: '.+')))
      mail.body.encoded.should match("http://joblr.co/beta_invites/#{beta_invite.id}/edit")
    end

    it 'should have the correct invitation code' do
      mail.body.encoded.should match(beta_invite.code)
    end

    it 'should have a Sign up! button' do
      mail.body.encoded.should match(I18n.t('mailers.beta_invite.send_code.button'))
    end
  end
end