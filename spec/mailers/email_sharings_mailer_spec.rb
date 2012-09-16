require 'spec_helper'

describe EmailSharingMailer do

	describe "'user' method" do

		let(:author) 				{FactoryGirl.create :user}
		let(:profile)				{FactoryGirl.create :profile, user: author}
		let(:email_sharing) {FactoryGirl.create :email_sharing, profile: profile, author: author}
		let(:mail)	 				{EmailSharingMailer.user(email_sharing,author)}

		it 'should send the email with correct subject, author and recipient' do
			mail.subject.should == I18n.t('mailers.email_sharing.user.subject', fullname: author.fullname)
			mail.to.should == [email_sharing.recipient_email]
			mail.from.should == ['postman@joblr.co']
		end

		it 'should contain the title' do
			mail.body.encoded.should match(I18n.t('mailers.email_sharing.user.html.title', fullname: author.fullname))
		end

		it 'should contain summary' do
			mail.body.encoded.should match(I18n.t('mailers.email_sharing.user.html.summary', fullname: author.fullname))
		end

		it 'should contain text' do
			mail.body.encoded.should match(email_sharing.text)
		end

		it 'should contain user information' do
			mail.body.encoded.should match(author.fullname)
			mail.body.encoded.should match(profile.experience)
			mail.body.encoded.should match(profile.last_job)
			mail.body.encoded.should match(profile.past_companies)			
			mail.body.encoded.should match(profile.education)
			mail.body.encoded.should match(profile.skill_1)
			mail.body.encoded.should match(profile.skill_2)
			mail.body.encoded.should match(profile.skill_3)
			mail.body.encoded.should match(profile.quality_1)
			mail.body.encoded.should match(profile.quality_2)
			mail.body.encoded.should match(profile.quality_3)									
		end

		it 'should have contact link' do
			mail.body.encoded.should match("mailto:#{author.email}")
		end

		it 'should have decline link' do
			mail.body.encoded.should match("http://joblr.co/email_sharings/#{email_sharing.id}/decline")
		end
	end

	describe "'other user' method" do
		let(:shared_user) 	{FactoryGirl.create :user}
		let(:profile)				{FactoryGirl.create :profile, user: shared_user}
		let(:current_user) 	{FactoryGirl.create :user, fullname: FactoryGirl.generate(:fullname), username: FactoryGirl.generate(:username), email: FactoryGirl.generate(:email)}
		let(:email_sharing)	{FactoryGirl.create :email_sharing, profile: profile, author: current_user}
		let(:mail)	 				{EmailSharingMailer.other_user(email_sharing,shared_user,current_user)}

		it 'should send the email with correct subject, author and recipient' do
			mail.subject.should == I18n.t('mailers.email_sharing.other_user.subject', fullname: current_user.fullname)
			mail.to.should == [email_sharing.recipient_email]
			mail.from.should == ['postman@joblr.co']
		end

		it 'should contain the title' do
			mail.body.encoded.should match(I18n.t('mailers.email_sharing.other_user.html.title', fullname: shared_user.fullname))
		end

		it 'should contain summary' do
			mail.body.encoded.should match(I18n.t('mailers.email_sharing.other_user.html.summary', author_fullname: current_user.fullname, user_fullname: shared_user.fullname))
		end

		it 'should contain text' do
			mail.body.encoded.should match(email_sharing.text)
		end

		it 'should contain author information' do
			mail.body.encoded.should match(current_user.fullname)
			mail.body.encoded.should match(current_user.email)
		end	

		it 'should contain shared_user information' do
			mail.body.encoded.should match(shared_user.fullname)
			mail.body.encoded.should match(profile.experience)
			mail.body.encoded.should match(profile.last_job)
			mail.body.encoded.should match(profile.past_companies)			
			mail.body.encoded.should match(profile.education)
			mail.body.encoded.should match(profile.skill_1)
			mail.body.encoded.should match(profile.skill_2)
			mail.body.encoded.should match(profile.skill_3)
			mail.body.encoded.should match(profile.quality_1)
			mail.body.encoded.should match(profile.quality_2)
			mail.body.encoded.should match(profile.quality_3)									
		end

		it 'should have contact link' do
			mail.body.encoded.should match("mailto:#{shared_user.email}")
		end

		it 'should have decline link' do
			mail.body.encoded.should match("http://joblr.co/email_sharings/#{email_sharing.id}/decline")
		end
	end

	describe "'public user' method" do
		let(:shared_user) 	{FactoryGirl.create :user}
		let(:profile)				{FactoryGirl.create :profile, user: shared_user}
		let(:public_user) 	{FactoryGirl.create :user, fullname: FactoryGirl.generate(:fullname), username: FactoryGirl.generate(:username), email: FactoryGirl.generate(:email)}
		let(:email_sharing)	{FactoryGirl.create :email_sharing, profile: profile, author: public_user}
		let(:mail)	 				{EmailSharingMailer.public_user(email_sharing,shared_user)}

		it 'should send the email with correct subject, author and recipient' do
			mail.subject.should == I18n.t('mailers.email_sharing.public_user.subject', fullname: email_sharing.author_fullname)
			mail.to.should == [email_sharing.recipient_email]
			mail.from.should == ['postman@joblr.co']
		end

		it 'should contain the title' do
			mail.body.encoded.should match(I18n.t('mailers.email_sharing.public_user.html.title', fullname: shared_user.fullname))
		end

		it 'should contain summary' do
			mail.body.encoded.should match(I18n.t('mailers.email_sharing.public_user.html.summary', author_fullname: email_sharing.author_fullname, user_fullname: shared_user.fullname))
		end

		it 'should contain text' do
			mail.body.encoded.should match(email_sharing.text)
		end

		it 'should contain author information' do
			mail.body.encoded.should match(email_sharing.author_fullname)
			mail.body.encoded.should match(email_sharing.author_email)
		end	

		it 'should contain shared_user information' do
			mail.body.encoded.should match(shared_user.fullname)
			mail.body.encoded.should match(profile.experience)
			mail.body.encoded.should match(profile.last_job)
			mail.body.encoded.should match(profile.past_companies)			
			mail.body.encoded.should match(profile.education)
			mail.body.encoded.should match(profile.skill_1)
			mail.body.encoded.should match(profile.skill_2)
			mail.body.encoded.should match(profile.skill_3)
			mail.body.encoded.should match(profile.quality_1)
			mail.body.encoded.should match(profile.quality_2)
			mail.body.encoded.should match(profile.quality_3)									
		end

		it 'should have contact link' do
			mail.body.encoded.should match("mailto:#{shared_user.email}")
		end

		it 'should have decline link' do
			mail.body.encoded.should match("http://joblr.co/email_sharings/#{email_sharing.id}/decline")
		end
	end

	describe "'decline' method" do
		let(:user) 					{FactoryGirl.create :user}
		let(:profile)				{FactoryGirl.create :profile, user: user}
		let(:email_sharing) {FactoryGirl.create :email_sharing, profile: profile, author: user}
		let(:mail)	 				{EmailSharingMailer.decline(email_sharing)}

		it 'should send the email with correct subject, author and recipient' do
			mail.subject.should == I18n.t('mailers.email_sharing.decline.subject', fullname: email_sharing.recipient_fullname)
			mail.to.should == [user.email]
			mail.from.should == ['postman@joblr.co']
		end

		it 'should have a title' do
			mail.body.encoded.should match(I18n.t('mailers.email_sharing.decline.title', fullname: email_sharing.recipient_fullname))
		end

		it 'should have content' do
			mail.body.encoded.should match(I18n.t('mailers.email_sharing.decline.content', fullname: email_sharing.recipient_fullname))
		end
		
		it 'should have perseverance message' do
			mail.body.encoded.should match(I18n.t('mailers.email_sharing.decline.persevere'))
		end	
	end

	describe "'other decline' method" do
		let(:user) 					{FactoryGirl.create :user}
		let(:profile)				{FactoryGirl.create :profile, user: user}
		let(:user2) 	{FactoryGirl.create :user, fullname: FactoryGirl.generate(:fullname), username: FactoryGirl.generate(:username), email: FactoryGirl.generate(:email)}
		let(:email_sharing) {FactoryGirl.create :email_sharing, profile: profile, author: user2}
		let(:mail)	 				{EmailSharingMailer.other_decline(email_sharing)}

		it 'should send the email with correct subject, author and recipient' do
			mail.subject.should == I18n.t('mailers.email_sharing.other_decline.subject', fullname: email_sharing.recipient_fullname)
			mail.to.should == [user.email]
			mail.from.should == ['postman@joblr.co']
		end

		it 'should have a title' do
			mail.body.encoded.should match(I18n.t('mailers.email_sharing.other_decline.title', fullname: email_sharing.recipient_fullname))
		end

		it 'should have content' #do ##FIX ME!
			#mail.body.encoded.should match(I18n.t('mailers.email_sharing.other_decline.content', fullname: email_sharing.recipient_fullname, author_fullname: user2.fullname))
		end
		
		it 'should have perseverance message' do
			mail.body.encoded.should match(I18n.t('mailers.email_sharing.other_decline.persevere'))
		end	
	end
end