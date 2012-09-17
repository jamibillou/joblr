require 'spec_helper'

describe EmailSharingsController do

  render_views

  before :each do
    @author        = FactoryGirl.create :user
    @other_user    = FactoryGirl.create :user, fullname: FactoryGirl.generate(:fullname), username: FactoryGirl.generate(:username), email: FactoryGirl.generate(:email)
    @other_profile = FactoryGirl.create :profile, user: @other_user
    @public_user   = { fullname: 'Public User', email: 'public_user@example.com' }
    @profile_attr  = { headline: 'fulltime',
                      experience: '5 yrs',
                      last_job: 'Financial director',
                      past_companies: 'Cathay Pacific, Bank of China',
                      education: 'Master of Business Administration',
                      skill_1: 'Financial control',
                      skill_2: 'Business analysis',
                      skill_3: 'Strategic decision making',
                      skill_1_level: 'Expert',
                      skill_2_level: 'Beginner',
                      skill_3_level: 'Intermediate',
                      quality_1: 'Drive',
                      quality_2: 'Work ethics',
                      quality_3: 'Punctuality',
                      text: 'Do or do not, there is no try.' }
    @email_sharing_attr = { text: "Hi, I'm really keen to work for your company and would love to go over a few ideas together soon." }
  end

  describe "POST 'create'" do

    before :each do
      @author.profiles.create @profile_attr
    end

    context 'for signed-in users' do

      before :each do
        sign_in @author
      end

      context 'sharing their own profile' do

        context "and not providing any email address" do

          it 'should not create a new email_sharing object' do
            lambda do
              xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_fullname: 'Test Dude'), user_id: @author.id
            end.should_not change(EmailSharing, :count).by 1
          end

          it "should not send the user's profile by email" do
            email = mock Mail::Message
            EmailSharingMailer.should_not_receive(:user).with(kind_of(EmailSharing), kind_of(User)).and_return(email)
            email.should_not_receive(:deliver)
            xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_fullname: 'Test Dude'), user_id: @author.id
          end

          it 'should have an error messsage' do
            xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_fullname: 'Test Dude'), user_id: @author.id
            response.body.should == I18n.t('flash.error.required.all')
          end
        end

        context "and not providing any full name" do

          it 'should not create a new email_sharing object' do
            lambda do
              xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_email: 'user@example.com'), user_id: @author.id
            end.should_not change(EmailSharing, :count).by 1
          end

          it "should send the user's profile by email" do
            email = mock Mail::Message
            EmailSharingMailer.should_not_receive(:user).with(kind_of(EmailSharing), kind_of(User)).and_return(email)
            email.should_not_receive(:deliver)
            xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_email: 'user@example.com'), user_id: @author.id
          end

          it 'should have an error messsage' do
            xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_email: 'user@example.com'), user_id: @author.id
            response.body.should == I18n.t('flash.error.required.all')
          end
        end

        context 'and providing an email address and full name' do

          after :each do
            EmailSharingMailer.deliveries.clear
          end

          it 'should create a new email_sharing object' do
            lambda do
              xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_email: 'user@example.com', recipient_fullname: 'Test Dude'), user_id: @author.id
            end.should change(EmailSharing, :count).by 1
          end

          it "should send the user's profile by email" do
            email = mock Mail::Message
            EmailSharingMailer.should_receive(:user).with(kind_of(EmailSharing), kind_of(User)).and_return(email)
            email.should_receive(:deliver)
            xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_email: 'user@example.com', recipient_fullname: 'Test Dude'), user_id: @author.id
          end

          it "should send the email to the right person with the right subject and profile" do
            xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_email: 'user@example.com', recipient_fullname: 'Test Dude'), user_id: @author.id
            EmailSharingMailer.deliveries.last.to.should include 'user@example.com'
            EmailSharingMailer.deliveries.last.subject.should == I18n.t('mailers.email_sharing.user.subject', fullname: @author.fullname)
          end

          it "should have a flash message" do
            xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_email: 'user@example.com', recipient_fullname: 'Test Dude'), user_id: @author.id
            flash[:success].should == I18n.t('flash.success.profile.shared', recipient_email: 'user@example.com')
          end
        end
      end

      context "sharing another user's profile" do

        context "and not providing any email address" do

          it 'should not create a new email_sharing object' do
            lambda do
              xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_fullname: 'Test Dude'), user_id: @other_user.id
            end.should_not change(EmailSharing, :count).by 1
          end

          it "should not send the other user's profile by email" do
            email = mock Mail::Message
            EmailSharingMailer.should_not_receive(:other_user).with(kind_of(EmailSharing), kind_of(User), kind_of(User)).and_return(email)
            email.should_not_receive(:deliver)
            xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_fullname: 'Test Dude'), user_id: @other_user.id
          end

          it 'should have an error messsage' do
            xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_fullname: 'Test Dude'), user_id: @other_user.id
            response.body.should == I18n.t('flash.error.required.all')
          end
        end

        context "and not providing any full name" do

          it 'should not create a new email_sharing object' do
            lambda do
              xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_email: 'other_user@example.com'), user_id: @other_user.id
            end.should_not change(EmailSharing, :count).by 1
          end

          it "should not send the other user's profile by email" do
            email = mock Mail::Message
            EmailSharingMailer.should_not_receive(:other_user).with(kind_of(EmailSharing), kind_of(User), kind_of(User)).and_return(email)
            email.should_not_receive(:deliver)
            xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_email: 'other_user@example.com'), user_id: @other_user.id
          end

          it 'should have an error messsage' do
            xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_email: 'other_user@example.com'), user_id: @other_user.id
            response.body.should == I18n.t('flash.error.required.all')
          end
        end

        context 'and providing an email address and full name' do

          after :each do
            EmailSharingMailer.deliveries.clear
          end

          it 'should create a new email_sharing object' do
            lambda do
              xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_email: 'other_user@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
            end.should change(EmailSharing, :count).by 1
          end

          it "should send the other user's profile by email" do
            email = mock Mail::Message
            EmailSharingMailer.should_receive(:other_user).with(kind_of(EmailSharing), kind_of(User), kind_of(User)).and_return(email)
            email.should_receive(:deliver)
            xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_email: 'other_user@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
          end

          it "should send the email to the right person with the right subject and profile" do
            xhr :post, :create, :email_sharing => @email_sharing_attr.merge(recipient_email: 'other_user@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
            EmailSharingMailer.deliveries.last.to.should include 'other_user@example.com'
            EmailSharingMailer.deliveries.last.subject.should == I18n.t('mailers.email_sharing.other_user.subject', fullname: @author.fullname)
          end

          it "should have a flash message" do
            xhr :post, :create, :email_sharing => @email_sharing_attr.merge(profile: @other_profile, recipient_email: 'other_user@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
            flash[:success].should == I18n.t('flash.success.profile.other_shared', recipient_email: 'other_user@example.com', fullname: @other_user.fullname)
          end
        end
      end
    end

    context 'for public users' do

      context "who didn't provide any author email address" do

        it 'should not create a new email_sharing object' do
          lambda do
            xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_fullname: @public_user[:fullname], recipient_email: 'recipient@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
          end.should_not change(EmailSharing, :count).by 1
        end

        it "should not send the user's profile by email" do
          email = mock Mail::Message
          EmailSharingMailer.should_not_receive(:public_user).with(kind_of(EmailSharing), kind_of(User)).and_return(email)
          email.should_not_receive(:deliver)
          xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_fullname: @public_user[:fullname], recipient_email: 'recipient@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
        end

        it 'should have an error messsage' do
          xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_fullname: @public_user[:fullname], recipient_email: 'recipient@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
          response.body.should == I18n.t('flash.error.required.all')
        end
      end

      context "who didn't provide any author full name" do

        it 'should not create a new email_sharing object' do
          lambda do
            xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_email: @public_user[:email], recipient_email: 'recipient@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
          end.should_not change(EmailSharing, :count).by 1
        end

        it "should not send the user's profile by email" do
          email = mock Mail::Message
          EmailSharingMailer.should_not_receive(:public_user).with(kind_of(EmailSharing), kind_of(User)).and_return(email)
          email.should_not_receive(:deliver)
          xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_email: @public_user[:email], recipient_email: 'recipient@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
        end

        it 'should have an error messsage' do
          xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_email: @public_user[:email], recipient_email: 'recipient@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
          response.body.should == I18n.t('flash.error.required.all')
        end
      end

      context "who didn't provide any recipient email" do

        it 'should not create a new email_sharing object' do
          lambda do
            xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_fullname: @public_user[:fullname], author_email: @public_user[:email], recipient_fullname: 'Test Dude'), user_id: @other_user.id
          end.should_not change(EmailSharing, :count).by 1
        end

        it "should not send the user's profile by email" do
          email = mock Mail::Message
          EmailSharingMailer.should_not_receive(:public_user).with(kind_of(EmailSharing), kind_of(User)).and_return(email)
          email.should_not_receive(:deliver)
          xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_fullname: @public_user[:fullname], author_email: @public_user[:email], recipient_fullname: 'Test Dude'), user_id: @other_user.id
        end

        it 'should have an error messsage' do
          xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_fullname: @public_user[:fullname], author_email: @public_user[:email], recipient_fullname: 'Test Dude'), user_id: @other_user.id
          response.body.should == I18n.t('flash.error.required.all')
        end
      end

      context "who didn't provide any recipient full name" do

        it 'should not create a new email_sharing object' do
          lambda do
            xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_fullname: @public_user[:fullname], author_email: @public_user[:email], recipient_email: 'recipient@example.com'), user_id: @other_user.id
          end.should_not change(EmailSharing, :count).by 1
        end

        it "should not send the user's profile by email" do
          email = mock Mail::Message
          EmailSharingMailer.should_not_receive(:public_user).with(kind_of(EmailSharing), kind_of(User)).and_return(email)
          email.should_not_receive(:deliver)
          xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_fullname: @public_user[:fullname], author_email: @public_user[:email], recipient_email: 'recipient@example.com'), user_id: @other_user.id
        end

        it 'should have an error messsage' do
          xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_fullname: @public_user[:fullname], author_email: @public_user[:email], recipient_email: 'recipient@example.com'), user_id: @other_user.id
          response.body.should == I18n.t('flash.error.required.all')
        end
      end

      context 'who provided all info' do

        after :each do
          EmailSharingMailer.deliveries.clear
        end

        it 'should create a new email_sharing object' do
          lambda do
            xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_email: @public_user[:email], author_fullname: @public_user[:fullname], recipient_email: 'recipient@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
          end.should change(EmailSharing, :count).by 1
        end

        it "should send the user's profile by email" do
          email = mock Mail::Message
          EmailSharingMailer.should_receive(:public_user).with(kind_of(EmailSharing), kind_of(User)).and_return(email)
          email.should_receive(:deliver)
          xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_email: @public_user[:email], author_fullname: @public_user[:fullname], recipient_email: 'recipient@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
        end

        it "should send the email to the right person with the right subject and profile" do
          xhr :post, :create, :email_sharing => @email_sharing_attr.merge(author_email: @public_user[:email], author_fullname: @public_user[:fullname], recipient_email: 'recipient@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
          EmailSharingMailer.deliveries.last.to.should include 'recipient@example.com'
          EmailSharingMailer.deliveries.last.subject.should == I18n.t('mailers.email_sharing.public_user.subject', fullname: @public_user[:fullname])
        end

        it "should have a flash message" do
          xhr :post, :create, :email_sharing => @email_sharing_attr.merge(profile: @other_profile, author_email: @public_user[:email], author_fullname: @public_user[:fullname], recipient_email: 'recipient@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
          flash[:success].should == I18n.t('flash.success.profile.public_shared', recipient_email: 'recipient@example.com', fullname: @other_user.fullname)
        end
      end
    end
  end

  describe "GET 'decline'" do

    before :each do
      @author.profiles.create @profile_attr
      @user_email_sharing   = EmailSharing.create!(@email_sharing_attr.merge(profile: @author.profile, author: @author,     recipient_email: 'user@example.com', recipient_fullname: 'User Recipient', status: nil))
      @other_email_sharing  = EmailSharing.create!(@email_sharing_attr.merge(profile: @author.profile, author: @other_user, recipient_email: 'other_user@example.com', recipient_fullname: 'Other User Recipient', status: nil))
      @public_email_sharing = EmailSharing.create!(@email_sharing_attr.merge(profile: @author.profile, author: nil, author_email: @public_user[:email], author_fullname: @public_user[:fullname], recipient_email: 'recipient@example.com', recipient_fullname: 'Public User Recipient', status: nil))
    end

    context 'for email_sharings that have already been answered' do

      before :each do
        @user_email_sharing.update_attributes   status: 'declined'
        @other_email_sharing.update_attributes  status: 'declined'
        @public_email_sharing.update_attributes status: 'declined'
      end

      it 'should redirect to already_answered_path' do
        get :decline, email_sharing_id: @user_email_sharing
        response.should redirect_to email_sharing_already_answered_path
        get :decline, email_sharing_id: @other_email_sharing
        response.should redirect_to email_sharing_already_answered_path
        get :decline, email_sharing_id: @public_email_sharing
        response.should redirect_to email_sharing_already_answered_path
      end

      it 'should not send any email' do
        email = mock Mail::Message
        EmailSharingMailer.should_not_receive(:decline).with(kind_of(EmailSharing)).and_return(email)
        EmailSharingMailer.should_not_receive(:decline_through_other).with(kind_of(EmailSharing)).and_return(email)
        email.should_not_receive(:deliver)
        get :decline, email_sharing_id: @user_email_sharing
        get :decline, email_sharing_id: @other_email_sharing
        get :decline, email_sharing_id: @public_email_sharing
      end
    end

    context "for email_sharings that have not been answered yet" do

      context "and were sent by the user himself" do

        after :each do
          EmailSharingMailer.deliveries.clear
        end

        it { get :decline, email_sharing_id: @user_email_sharing ; response.should be_success }

        it 'should update the status' do
          get :decline, email_sharing_id: @user_email_sharing
          @user_email_sharing.reload
          @user_email_sharing.status.should == 'declined'
        end

        it 'should send a decline notification email' do
          email = mock Mail::Message
          EmailSharingMailer.should_receive(:decline).with(kind_of(EmailSharing)).and_return(email)
          email.should_receive(:deliver)
          get :decline, email_sharing_id: @user_email_sharing
        end

        it "should send the email to the right user with the right subject" do
          get :decline, email_sharing_id: @user_email_sharing
          EmailSharingMailer.deliveries.last.to.should include @author.email
          EmailSharingMailer.deliveries.last.subject.should == I18n.t('mailers.email_sharing.decline.subject', fullname: @user_email_sharing.recipient_fullname)
        end

        it 'should have a thank you message' do
          get :decline, email_sharing_id: @user_email_sharing
          response.body.should have_content I18n.t('email_sharings.decline.thank_you')
        end
      end

      context "and were sent by another user" do

        after :each do
          EmailSharingMailer.deliveries.clear
        end

        it { get :decline, email_sharing_id: @other_email_sharing ; response.should be_success }

        it 'should update the status' do
          get :decline, email_sharing_id: @other_email_sharing
          @other_email_sharing.reload
          @other_email_sharing.status.should == 'declined'
        end

        it 'should send an other decline notification email' do
          email = mock Mail::Message
          EmailSharingMailer.should_receive(:decline_through_other).with(kind_of(EmailSharing)).and_return(email)
          email.should_receive(:deliver)
          get :decline, email_sharing_id: @other_email_sharing
        end

        it "should send the email to the right user with the right subject" do
          get :decline, email_sharing_id: @other_email_sharing
          EmailSharingMailer.deliveries.last.to.should include @author.email
          EmailSharingMailer.deliveries.last.subject.should == I18n.t('mailers.email_sharing.decline.subject', fullname: @other_email_sharing.recipient_fullname)
        end

        it 'should a have thank you message' do
          get :decline, email_sharing_id: @other_email_sharing
          response.body.should have_content I18n.t('email_sharings.decline.thank_you')
        end
      end

      context "and were sent by a public user"  do

        after :each do
          EmailSharingMailer.deliveries.clear
        end

        it { get :decline, email_sharing_id: @public_email_sharing ; response.should be_success }

        it 'should update the status' do
          get :decline, email_sharing_id: @public_email_sharing
          @public_email_sharing.reload
          @public_email_sharing.status.should == 'declined'
        end

        it 'should send a decline notification email' do
          email = mock Mail::Message
          EmailSharingMailer.should_receive(:decline_through_other).with(kind_of(EmailSharing)).and_return(email)
          email.should_receive(:deliver)
          get :decline, email_sharing_id: @public_email_sharing
        end

        it "should send the email to the right user with the right subject" do
          get :decline, email_sharing_id: @public_email_sharing
          EmailSharingMailer.deliveries.last.to.should include @author.email
          EmailSharingMailer.deliveries.last.subject.should == I18n.t('mailers.email_sharing.decline.subject', fullname: @public_email_sharing.recipient_fullname)
        end

        it 'should a have thank you message' do
          get :decline, email_sharing_id: @public_email_sharing
          response.body.should have_content I18n.t('email_sharings.decline.thank_you')
        end
      end
    end

    describe "GET 'already_answered'" do

      before :each do
        @author.profiles.create @profile_attr
        @user_email_sharing   = EmailSharing.create!(@email_sharing_attr.merge(profile: @author.profile, author: @author,     recipient_email: 'user@example.com', recipient_fullname: 'User Recipient', status: nil))
        @other_email_sharing  = EmailSharing.create!(@email_sharing_attr.merge(profile: @author.profile, author: @other_user, recipient_email: 'other_user@example.com', recipient_fullname: 'Other User Recipient', status: nil))
        @public_email_sharing = EmailSharing.create!(@email_sharing_attr.merge(profile: @author.profile, author: nil, author_email: @public_user[:email], author_fullname: @public_user[:fullname], recipient_email: 'recipient@example.com', recipient_fullname: 'Public User Recipient', status: nil))
      end

      context 'for email sharings that were sent by the user himself' do

        it { get :already_answered, email_sharing_id: @user_email_sharing   ; response.should be_success }

        it 'should a have thank you message' do
          get :already_answered, email_sharing_id: @user_email_sharing
          response.body.should include I18n.t('email_sharings.already_answered.thank_you', fullname: @user_email_sharing.profile.user.fullname)
        end
      end

      context 'for email sharings that were sent by another user' do

        it { get :already_answered, email_sharing_id: @other_email_sharing  ; response.should be_success }

        it 'should a have thank you message' do
          get :already_answered, email_sharing_id: @other_email_sharing
          response.body.should include I18n.t('email_sharings.already_answered.thank_you', fullname: @other_email_sharing.profile.user.fullname)
        end
      end

      context 'for email sharings that were sent by a public user' do

        it { get :already_answered, email_sharing_id: @public_email_sharing ; response.should be_success }

        it 'should a have thank you message' do
          get :already_answered, email_sharing_id: @public_email_sharing
          response.body.should include I18n.t('email_sharings.already_answered.thank_you', fullname: @public_email_sharing.profile.user.fullname)
        end
      end
    end
  end
end