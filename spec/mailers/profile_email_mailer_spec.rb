require 'spec_helper'

describe ProfileEmailMailer do

  describe "'user' method" do

    let (:user)          { FactoryGirl.create :user }
    let (:profile)       { FactoryGirl.create :profile, user: user }
    let (:profile_email) { FactoryGirl.create :profile_email, profile: profile, author: user }
    let (:mail)          { ProfileEmailMailer.user(profile_email, user) }

    it 'should send the email with correct subject, author and recipient' do
      mail.subject.should == I18n.t('mailers.profile_email.user.subject', fullname: user.fullname)
      mail.to.should   include profile_email.recipient_email
      mail.from.should include 'postman@joblr.co'
    end

    it 'should have a title' do
      mail.body.encoded.should include I18n.t('mailers.profile_email.user.html.title', fullname: user.fullname)
    end

    it 'should have a summary' do
      mail.body.encoded.should include I18n.t('mailers.profile_email.user.html.summary', fullname: user.fullname)
    end

    it 'should have a text' do
      mail.body.encoded.should include profile_email.text
    end

    it "should have the user's picture" do
      mail.body.encoded.should include 'default_user.jpg'
    end

    it "should have the user's profile information" do
      mail.body.encoded.should include user.fullname
      mail.body.encoded.should include "#{profile.experience} yrs"
      mail.body.encoded.should include profile.last_job
      mail.body.encoded.should include profile.past_companies
      mail.body.encoded.should include profile.education
      mail.body.encoded.should include profile.skill_1
      mail.body.encoded.should include profile.skill_2
      mail.body.encoded.should include profile.skill_3
      mail.body.encoded.should include profile.quality_1
      mail.body.encoded.should include profile.quality_2
      mail.body.encoded.should include profile.quality_3
    end

    it 'should have a contact link' do
      mail.body.encoded.should match("mailto:#{user.email}")
    end

    it 'should have a decline link' do
      mail.body.encoded.should match("http://joblr.co/profile_emails/#{profile_email.id}/decline")
    end
  end

  describe "'other_user' method" do

    let (:user)          { FactoryGirl.create :user }
    let (:profile)       { FactoryGirl.create :profile, user: user }
    let (:current_user)  { FactoryGirl.create :user, fullname: FactoryGirl.generate(:fullname), username: FactoryGirl.generate(:username), email: FactoryGirl.generate(:email) }
    let (:profile_email) { FactoryGirl.create :profile_email, profile: profile, author: current_user }
    let (:mail)          { ProfileEmailMailer.other_user(profile_email, user, current_user) }

    it 'should send the email with correct subject, author and recipient' do
      mail.subject.should == I18n.t('mailers.profile_email.other_user.subject', author_fullname: current_user.fullname, user_fullname: user.fullname)
      mail.to.should   include profile_email.recipient_email
      mail.from.should include 'postman@joblr.co'
    end

    it 'should have a title' do
      mail.body.encoded.should include I18n.t('mailers.profile_email.other_user.html.title', fullname: user.fullname)
    end

    it 'should have a summary' do
      mail.body.encoded.should include I18n.t('mailers.profile_email.other_user.html.summary', author_fullname: current_user.fullname, user_fullname: user.fullname)
    end

    it 'should have a text' do
      mail.body.encoded.should include profile_email.text
    end

    it "should have the author's information" do
      mail.body.encoded.should include current_user.fullname
      mail.body.encoded.should include current_user.email
    end

    it "should have the user's picture" do
      mail.body.encoded.should include 'default_user.jpg'
    end

    it "should have the user's profile information" do
      mail.body.encoded.should include user.fullname
      mail.body.encoded.should include "#{profile.experience} yrs"
      mail.body.encoded.should include profile.last_job
      mail.body.encoded.should include profile.past_companies
      mail.body.encoded.should include profile.education
      mail.body.encoded.should include profile.skill_1
      mail.body.encoded.should include profile.skill_2
      mail.body.encoded.should include profile.skill_3
      mail.body.encoded.should include profile.quality_1
      mail.body.encoded.should include profile.quality_2
      mail.body.encoded.should include profile.quality_3
    end

    it 'should have a contact link' do
      mail.body.encoded.should include "mailto:#{user.email}"
    end

    it 'should have a decline link' do
      mail.body.encoded.should include "http://joblr.co/profile_emails/#{profile_email.id}/decline"
    end
  end

  describe "'public_user' method" do
    let (:user)          { FactoryGirl.create :user}
    let (:profile)       { FactoryGirl.create :profile, user: user }
    let (:public_user)   { FactoryGirl.create :user, fullname: FactoryGirl.generate(:fullname), username: FactoryGirl.generate(:username), email: FactoryGirl.generate(:email) }
    let (:profile_email) { FactoryGirl.create :profile_email, profile: profile, author: public_user }
    let (:mail)          { ProfileEmailMailer.public_user(profile_email, user) }

    it 'should send the email with correct subject, author and recipient' do
      mail.subject.should == I18n.t('mailers.profile_email.public_user.subject', author_fullname: profile_email.author_fullname, user_fullname: user.fullname)
      mail.to.should   include profile_email.recipient_email
      mail.from.should include 'postman@joblr.co'
    end

    it 'should have a title' do
      mail.body.encoded.should include I18n.t('mailers.profile_email.public_user.html.title', fullname: user.fullname)
    end

    it 'should have a summary' do
      mail.body.encoded.should include I18n.t('mailers.profile_email.public_user.html.summary', author_fullname: profile_email.author_fullname, user_fullname: user.fullname)
    end

    it 'should have a text' do
      mail.body.encoded.should include profile_email.text
    end

    it "should have the author's information" do
      mail.body.encoded.should include profile_email.author_fullname
      mail.body.encoded.should include profile_email.author_email
    end

    it "should have the user's picture" do
      mail.body.encoded.should match('default_user.jpg')
    end

    it "should have the user's profile information" do
      mail.body.encoded.should include user.fullname
      mail.body.encoded.should include "#{profile.experience} yrs"
      mail.body.encoded.should include profile.last_job
      mail.body.encoded.should include profile.past_companies
      mail.body.encoded.should include profile.education
      mail.body.encoded.should include profile.skill_1
      mail.body.encoded.should include profile.skill_2
      mail.body.encoded.should include profile.skill_3
      mail.body.encoded.should include profile.quality_1
      mail.body.encoded.should include profile.quality_2
      mail.body.encoded.should include profile.quality_3
    end

    it 'should have a contact link' do
      mail.body.encoded.should include "mailto:#{user.email}"
    end

    it 'should have a decline link' do
      mail.body.encoded.should include "http://joblr.co/profile_emails/#{profile_email.id}/decline"
    end
  end

  describe "'decline' method" do

    let (:user)          { FactoryGirl.create :user }
    let (:profile)       { FactoryGirl.create :profile, user: user }
    let (:profile_email) { FactoryGirl.create :profile_email, profile: profile, author: user}
    let (:mail)          { ProfileEmailMailer.decline(profile_email) }

    it 'should send the email with correct subject, author and recipient' do
      mail.subject.should == I18n.t('mailers.profile_email.decline.subject', fullname: profile_email.recipient_fullname)
      mail.to.should   include user.email
      mail.from.should include 'postman@joblr.co'
    end

    it 'should have a title' do
      mail.body.encoded.should include I18n.t('mailers.profile_email.decline.title', fullname: profile_email.recipient_fullname)
    end

    it 'should have a content' do
      mail.body.encoded.should include I18n.t('mailers.profile_email.decline.content', fullname: profile_email.recipient_fullname)
    end

    it 'should have a persevere message' do
      mail.body.encoded.should include I18n.t('mailers.profile_email.decline.persevere')
    end
  end

  describe "'decline_through_other' method" do

    let (:user)          { FactoryGirl.create :user }
    let (:profile)       { FactoryGirl.create :profile, user: user }
    let (:author)        { FactoryGirl.create :user, fullname: FactoryGirl.generate(:fullname), username: FactoryGirl.generate(:username), email: FactoryGirl.generate(:email) }
    let (:profile_email) { FactoryGirl.create :profile_email, profile: profile, author: author }
    let (:mail)          { ProfileEmailMailer.decline_through_other(profile_email) }

    it 'should send the email with correct subject, author and recipient' do
      mail.subject.should == I18n.t('mailers.profile_email.decline_through_other.subject', author_fullname: author.fullname, recipient_fullname: profile_email.recipient_fullname)
      mail.to.should   include user.email
      mail.from.should include 'postman@joblr.co'
    end

    it 'should have a title' do
      mail.body.encoded.should include I18n.t('mailers.profile_email.decline_through_other.title', recipient_fullname: profile_email.recipient_fullname)
    end

    it 'should have a content' do
      mail.body.encoded.should include I18n.t('mailers.profile_email.decline_through_other.content', recipient_fullname: profile_email.recipient_fullname, author_fullname: author.fullname)
    end

    it 'should have a persevere message' do
      mail.body.encoded.should include I18n.t('mailers.profile_email.decline_through_other.persevere')
    end
  end
end