require 'spec_helper'

describe ProfileEmailsController do

  render_views

  before :each do
    @author        = FactoryGirl.create :user
    @other_user    = FactoryGirl.create :user, fullname: FactoryGirl.generate(:fullname), username: FactoryGirl.generate(:username), email: FactoryGirl.generate(:email)
    @other_profile = FactoryGirl.create :profile, user: @other_user
    @public_user   = { fullname: 'Public User', email: 'public_user@example.com' }
    @profile_attr  = { experience: 5,
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
                      quality_3: 'Punctuality' }
    @profile_email_attr = { text: "Hi, I'm really keen to work for your company and would love to go over a few ideas together soon." }
    @profile_email = FactoryGirl.create :profile_email, author: @author, profile: @other_profile

  end

  describe "GET 'new'" do

    context 'for public users' do

      it 'should redirect to root path' do
        get :new
        response.should redirect_to(root_path)
      end

      it 'should have an error message' do
        get :new
        flash[:error].should == I18n.t('flash.error.only.signed_in')
      end
    end

    context 'for signed-in users' do

      context "who haven't created their profile yet" do

        before :each do
          sign_in @author
        end

        it 'should redirect to root path' do
          get :new
          response.should redirect_to(root_path)
        end

        it 'should not have an error message' do
          get :new
          flash[:error].should be_nil
        end
      end

      context "who have a profile and have already sent it by email" do

        before :each do
          sign_in @author
          @author.profiles.create @profile_attr
          FactoryGirl.create :profile_email, author: @author, profile: @author.profile
        end

        it 'should redirect to root path' do
          get :new
          response.should redirect_to(root_path)
        end

        it 'should have an error message' do
          get :new
          flash[:error].should == I18n.t('flash.error.profile_email.already_sent')
        end
      end

      context "who have a profile but haven't sent it by email yet" do

        before :each do
          sign_in @other_user
          @other_user.profiles.create @profile_attr
          visit new_profile_email_path
        end

        it { response.should be_success }

        ## Add a test for page content
      end
    end
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

        context 'using modal from dashboard' do

          context "and not providing any email address" do

            it 'should not create a new profile_email object' do
              lambda do
                xhr :post, :create, :profile_email => @profile_email_attr.merge(recipient_fullname: 'Test Dude'), user_id: @author.id
              end.should_not change(ProfileEmail, :count).by 1
            end

            it "should not send the user's profile by email" do
              email = mock Mail::Message
              ProfileEmailMailer.should_not_receive(:user).with kind_of(ProfileEmail), kind_of(User)
              email.should_not_receive(:deliver)
              xhr :post, :create, :profile_email => @profile_email_attr.merge(recipient_fullname: 'Test Dude'), user_id: @author.id
            end

            it 'should have an error messsage' do
              xhr :post, :create, :profile_email => @profile_email_attr.merge(recipient_fullname: 'Test Dude'), user_id: @author.id
              response.body.should == "#{I18n.t('activerecord.attributes.profile_email.recipient_email')} #{I18n.t('activerecord.errors.messages.invalid')}."
            end
          end

          context "and not providing any full name" do

            it 'should not create a new profile_email object' do
              lambda do
                xhr :post, :create, :profile_email => @profile_email_attr.merge(recipient_email: 'user@example.com'), user_id: @author.id
              end.should_not change(ProfileEmail, :count).by 1
            end

            it "should send the user's profile by email" do
              email = mock Mail::Message
              ProfileEmailMailer.should_not_receive(:user).with kind_of(ProfileEmail), kind_of(User)
              email.should_not_receive(:deliver)
              xhr :post, :create, :profile_email => @profile_email_attr.merge(recipient_email: 'user@example.com'), user_id: @author.id
            end

            it 'should have an error messsage' do
              xhr :post, :create, :profile_email => @profile_email_attr.merge(recipient_email: 'user@example.com'), user_id: @author.id
              response.body.should == "#{I18n.t('activerecord.attributes.profile_email.recipient_fullname')} #{I18n.t('activerecord.errors.messages.blank')}."
            end
          end

          context 'and providing an email address and full name' do

            after :each do
              ProfileEmailMailer.deliveries.clear
            end

            it 'should create a new profile_email object' do
              lambda do
                xhr :post, :create, :profile_email => @profile_email_attr.merge(recipient_email: 'user@example.com', recipient_fullname: 'Test Dude'), user_id: @author.id
              end.should change(ProfileEmail, :count).by 1
            end

            it "should send the user's profile by email" do
              email = mock Mail::Message
              ProfileEmailMailer.should_receive(:current_user).with(kind_of(ProfileEmail), kind_of(User)).and_return(email)
              email.should_receive(:deliver)
              xhr :post, :create, :profile_email => @profile_email_attr.merge(recipient_email: 'user@example.com', recipient_fullname: 'Test Dude'), user_id: @author.id
            end

            it "should send the email to the right person with the right subject and profile" do
              xhr :post, :create, :profile_email => @profile_email_attr.merge(recipient_email: 'user@example.com', recipient_fullname: 'Test Dude'), user_id: @author.id
              ProfileEmailMailer.deliveries.last.to.should include 'user@example.com'
              ProfileEmailMailer.deliveries.last.subject.should == I18n.t('mailers.profile_email.current_user.subject', fullname: @author.fullname)
            end

            it "should have a flash message" do
              xhr :post, :create, :profile_email => @profile_email_attr.merge(recipient_email: 'user@example.com', recipient_fullname: 'Test Dude'), user_id: @author.id
              flash[:success].should == I18n.t('flash.success.profile.shared.user', recipient_email: 'user@example.com')
            end
          end
        end

        context 'using the first application form' do

          context "and not providing any email address" do

            it 'should not create a new profile_email object' do
              lambda do
                post :create, :profile_email => @profile_email_attr.merge(recipient_fullname: 'Test Dude'), user_id: @author.id
              end.should_not change(ProfileEmail, :count).by 1
            end

            it "should not send the user's profile by email" do
              email = mock Mail::Message
              ProfileEmailMailer.should_not_receive(:user).with kind_of(ProfileEmail), kind_of(User)
              email.should_not_receive(:deliver)
              post :create, :profile_email => @profile_email_attr.merge(recipient_fullname: 'Test Dude'), user_id: @author.id
            end

            it "should render 'new'" do
              post :create, :profile_email => @profile_email_attr.merge(recipient_fullname: 'Test Dude'), user_id: @author.id
              response.should render_template :new
            end

            it 'should have an error messsage' do
              post :create, :profile_email => @profile_email_attr.merge(recipient_fullname: 'Test Dude'), user_id: @author.id
              flash[:error].should == "#{I18n.t('activerecord.attributes.profile_email.recipient_email')} #{I18n.t('activerecord.errors.messages.invalid')}."
            end
          end

          context "and not providing any full name" do

            it 'should not create a new profile_email object' do
              lambda do
                post :create, :profile_email => @profile_email_attr.merge(recipient_email: 'user@example.com'), user_id: @author.id
              end.should_not change(ProfileEmail, :count).by 1
            end

            it "should send the user's profile by email" do
              email = mock Mail::Message
              ProfileEmailMailer.should_not_receive(:user).with kind_of(ProfileEmail), kind_of(User)
              email.should_not_receive(:deliver)
              post :create, :profile_email => @profile_email_attr.merge(recipient_email: 'user@example.com'), user_id: @author.id
            end

            it "should render 'new'" do
              post :create, :profile_email => @profile_email_attr.merge(recipient_fullname: 'Test Dude'), user_id: @author.id
              response.should render_template :new
            end

            it 'should have an error messsage' do
              post :create, :profile_email => @profile_email_attr.merge(recipient_email: 'user@example.com'), user_id: @author.id
              flash[:error].should == errors('profile_email.recipient_fullname', 'blank')
            end
          end

          context 'and providing an email address and full name' do

            after :each do
              ProfileEmailMailer.deliveries.clear
            end

            it 'should create a new profile_email object' do
              lambda do
                post :create, :profile_email => @profile_email_attr.merge(recipient_email: 'user@example.com', recipient_fullname: 'Test Dude'), user_id: @author.id
              end.should change(ProfileEmail, :count).by 1
            end

            it "should send the user's profile by email" do
              email = mock Mail::Message
              ProfileEmailMailer.should_receive(:current_user).with(kind_of(ProfileEmail), kind_of(User)).and_return(email)
              email.should_receive(:deliver)
              post :create, :profile_email => @profile_email_attr.merge(recipient_email: 'user@example.com', recipient_fullname: 'Test Dude'), user_id: @author.id
            end

            it "should send the email to the right person with the right subject and profile" do
              post :create, :profile_email => @profile_email_attr.merge(recipient_email: 'user@example.com', recipient_fullname: 'Test Dude'), user_id: @author.id
              ProfileEmailMailer.deliveries.last.to.should include 'user@example.com'
              ProfileEmailMailer.deliveries.last.subject.should == I18n.t('mailers.profile_email.current_user.subject', fullname: @author.fullname)
            end

            it "should redirect to root path" do
              post :create, :profile_email => @profile_email_attr.merge(recipient_email: 'user@example.com', recipient_fullname: 'Test Dude'), user_id: @author.id
              response.should redirect_to(root_path)
            end

            it "should have a flash message" do
              post :create, :profile_email => @profile_email_attr.merge(recipient_email: 'user@example.com', recipient_fullname: 'Test Dude'), user_id: @author.id
              flash[:success].should == I18n.t('flash.success.profile.shared.user', recipient_email: 'user@example.com')
            end
          end
        end
      end

      context "sharing another user's profile" do

        context "and not providing any email address" do

          it 'should not create a new profile_email object' do
            lambda do
              xhr :post, :create, :profile_email => @profile_email_attr.merge(recipient_fullname: 'Test Dude'), user_id: @other_user.id
            end.should_not change(ProfileEmail, :count).by 1
          end

          it "should not send the other user's profile by email" do
            email = mock Mail::Message
            ProfileEmailMailer.should_not_receive(:other_user).with kind_of(ProfileEmail), kind_of(User), kind_of(User)
            email.should_not_receive(:deliver)
            xhr :post, :create, :profile_email => @profile_email_attr.merge(recipient_fullname: 'Test Dude'), user_id: @other_user.id
          end

          it 'should have an error messsage' do
            xhr :post, :create, :profile_email => @profile_email_attr.merge(recipient_fullname: 'Test Dude'), user_id: @other_user.id
            response.body.should == "#{I18n.t('activerecord.attributes.profile_email.recipient_email')} #{I18n.t('activerecord.errors.messages.invalid')}."
          end
        end

        context "and not providing any full name" do

          it 'should not create a new profile_email object' do
            lambda do
              xhr :post, :create, :profile_email => @profile_email_attr.merge(recipient_email: 'other_user@example.com'), user_id: @other_user.id
            end.should_not change(ProfileEmail, :count).by 1
          end

          it "should not send the other user's profile by email" do
            email = mock Mail::Message
            ProfileEmailMailer.should_not_receive(:other_user).with kind_of(ProfileEmail), kind_of(User), kind_of(User)
            email.should_not_receive(:deliver)
            xhr :post, :create, :profile_email => @profile_email_attr.merge(recipient_email: 'other_user@example.com'), user_id: @other_user.id
          end

          it 'should have an error messsage' do
            xhr :post, :create, :profile_email => @profile_email_attr.merge(recipient_email: 'other_user@example.com'), user_id: @other_user.id
            response.body.should == "#{I18n.t('activerecord.attributes.profile_email.recipient_fullname')} #{I18n.t('activerecord.errors.messages.blank')}."
          end
        end

        context 'and providing an email address and full name' do

          after :each do
            ProfileEmailMailer.deliveries.clear
          end

          it 'should create a new profile_email object' do
            lambda do
              xhr :post, :create, :profile_email => @profile_email_attr.merge(recipient_email: 'other_user@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
            end.should change(ProfileEmail, :count).by 1
          end

          it "should send the other user's profile by email" do
            email = mock Mail::Message
            ProfileEmailMailer.should_receive(:other_user).with(kind_of(ProfileEmail), kind_of(User), kind_of(User)).and_return(email)
            email.should_receive(:deliver)
            xhr :post, :create, :profile_email => @profile_email_attr.merge(recipient_email: 'other_user@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
          end

          it "should send the email to the right person with the right subject and profile" do
            xhr :post, :create, :profile_email => @profile_email_attr.merge(recipient_email: 'other_user@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
            ProfileEmailMailer.deliveries.last.to.should include 'other_user@example.com'
            ProfileEmailMailer.deliveries.last.subject.should == I18n.t('mailers.profile_email.other_user.subject', user_fullname: @other_user.fullname, author_fullname: @author.fullname)
          end

          it "should have a flash message" do
            xhr :post, :create, :profile_email => @profile_email_attr.merge(profile: @other_profile, recipient_email: 'other_user@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
            flash[:success].should == I18n.t('flash.success.profile.shared.other_user', recipient_email: 'other_user@example.com', fullname: @other_user.fullname)
          end
        end
      end
    end

    context 'for public users' do

      context "who didn't provide any author email address" do

        it 'should not create a new profile_email object' do
          lambda do
            xhr :post, :create, :profile_email => @profile_email_attr.merge(author_fullname: @public_user[:fullname], recipient_email: 'recipient@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
          end.should_not change(ProfileEmail, :count).by 1
        end

        it "should not send the user's profile by email" do
          email = mock Mail::Message
          ProfileEmailMailer.should_not_receive(:public_user).with kind_of(ProfileEmail), kind_of(User)
          email.should_not_receive(:deliver)
          xhr :post, :create, :profile_email => @profile_email_attr.merge(author_fullname: @public_user[:fullname], recipient_email: 'recipient@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
        end

        it 'should have an error messsage' do
          xhr :post, :create, :profile_email => @profile_email_attr.merge(author_fullname: @public_user[:fullname], recipient_email: 'recipient@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
          response.body.should == "#{I18n.t('activerecord.attributes.profile_email.author_email')} #{I18n.t('activerecord.errors.messages.invalid')}."
        end
      end

      context "who didn't provide any author full name" do

        it 'should not create a new profile_email object' do
          lambda do
            xhr :post, :create, :profile_email => @profile_email_attr.merge(author_email: @public_user[:email], recipient_email: 'recipient@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
          end.should_not change(ProfileEmail, :count).by 1
        end

        it "should not send the user's profile by email" do
          email = mock Mail::Message
          ProfileEmailMailer.should_not_receive(:public_user).with kind_of(ProfileEmail), kind_of(User)
          email.should_not_receive(:deliver)
          xhr :post, :create, :profile_email => @profile_email_attr.merge(author_email: @public_user[:email], recipient_email: 'recipient@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
        end

        it 'should have an error messsage' do
          xhr :post, :create, :profile_email => @profile_email_attr.merge(author_email: @public_user[:email], recipient_email: 'recipient@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
          response.body.should == "#{I18n.t('activerecord.attributes.profile_email.author_fullname')} #{I18n.t('activerecord.errors.messages.blank')}."
        end
      end

      context "who didn't provide any recipient email" do

        it 'should not create a new profile_email object' do
          lambda do
            xhr :post, :create, :profile_email => @profile_email_attr.merge(author_fullname: @public_user[:fullname], author_email: @public_user[:email], recipient_fullname: 'Test Dude'), user_id: @other_user.id
          end.should_not change(ProfileEmail, :count).by 1
        end

        it "should not send the user's profile by email" do
          email = mock Mail::Message
          ProfileEmailMailer.should_not_receive(:public_user).with kind_of(ProfileEmail), kind_of(User)
          email.should_not_receive(:deliver)
          xhr :post, :create, :profile_email => @profile_email_attr.merge(author_fullname: @public_user[:fullname], author_email: @public_user[:email], recipient_fullname: 'Test Dude'), user_id: @other_user.id
        end

        it 'should have an error messsage' do
          xhr :post, :create, :profile_email => @profile_email_attr.merge(author_fullname: @public_user[:fullname], author_email: @public_user[:email], recipient_fullname: 'Test Dude'), user_id: @other_user.id
          response.body.should == "#{I18n.t('activerecord.attributes.profile_email.recipient_email')} #{I18n.t('activerecord.errors.messages.invalid')}."
        end
      end

      context "who didn't provide any recipient full name" do

        it 'should not create a new profile_email object' do
          lambda do
            xhr :post, :create, :profile_email => @profile_email_attr.merge(author_fullname: @public_user[:fullname], author_email: @public_user[:email], recipient_email: 'recipient@example.com'), user_id: @other_user.id
          end.should_not change(ProfileEmail, :count).by 1
        end

        it "should not send the user's profile by email" do
          email = mock Mail::Message
          ProfileEmailMailer.should_not_receive(:public_user).with kind_of(ProfileEmail), kind_of(User)
          email.should_not_receive(:deliver)
          xhr :post, :create, :profile_email => @profile_email_attr.merge(author_fullname: @public_user[:fullname], author_email: @public_user[:email], recipient_email: 'recipient@example.com'), user_id: @other_user.id
        end

        it 'should have an error messsage' do
          xhr :post, :create, :profile_email => @profile_email_attr.merge(author_fullname: @public_user[:fullname], author_email: @public_user[:email], recipient_email: 'recipient@example.com'), user_id: @other_user.id
          response.body.should == "#{I18n.t('activerecord.attributes.profile_email.recipient_fullname')} #{I18n.t('activerecord.errors.messages.blank')}."
        end
      end

      context 'who provided all info' do

        after :each do
          ProfileEmailMailer.deliveries.clear
        end

        it 'should create a new profile_email object' do
          lambda do
            xhr :post, :create, :profile_email => @profile_email_attr.merge(author_email: @public_user[:email], author_fullname: @public_user[:fullname], recipient_email: 'recipient@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
          end.should change(ProfileEmail, :count).by 1
        end

        it "should send the user's profile by email" do
          email = mock Mail::Message
          ProfileEmailMailer.should_receive(:public_user).with(kind_of(ProfileEmail), kind_of(User)).and_return(email)
          email.should_receive(:deliver)
          xhr :post, :create, :profile_email => @profile_email_attr.merge(author_email: @public_user[:email], author_fullname: @public_user[:fullname], recipient_email: 'recipient@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
        end

        it "should send the email to the right person with the right subject and profile" do
          xhr :post, :create, :profile_email => @profile_email_attr.merge(author_email: @public_user[:email], author_fullname: @public_user[:fullname], recipient_email: 'recipient@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
          ProfileEmailMailer.deliveries.last.to.should include 'recipient@example.com'
          ProfileEmailMailer.deliveries.last.subject.should == I18n.t('mailers.profile_email.public_user.subject', user_fullname: @other_user.fullname, author_fullname: @public_user[:fullname])
        end

        it "should have a flash message" do
          xhr :post, :create, :profile_email => @profile_email_attr.merge(profile: @other_profile, author_email: @public_user[:email], author_fullname: @public_user[:fullname], recipient_email: 'recipient@example.com', recipient_fullname: 'Test Dude'), user_id: @other_user.id
          flash[:success].should == I18n.t('flash.success.profile.shared.public_user', recipient_email: 'recipient@example.com', fullname: @other_user.fullname)
        end
      end
    end
  end

  describe "GET 'decline'" do

    before :each do
      @author.profiles.create @profile_attr
      @user_profile_email   = ProfileEmail.create!(@profile_email_attr.merge(profile: @author.profile, author: @author,     recipient_email: 'user@example.com', recipient_fullname: 'User Recipient', status: nil))
      @other_profile_email  = ProfileEmail.create!(@profile_email_attr.merge(profile: @author.profile, author: @other_user, recipient_email: 'other_user@example.com', recipient_fullname: 'Other User Recipient', status: nil))
      @public_profile_email = ProfileEmail.create!(@profile_email_attr.merge(profile: @author.profile, author: nil, author_email: @public_user[:email], author_fullname: @public_user[:fullname], recipient_email: 'recipient@example.com', recipient_fullname: 'Public User Recipient', status: nil))
    end

    context 'for profile_emails that have already been answered' do

      before :each do
        @user_profile_email.update_attributes   status: 'declined'
        @other_profile_email.update_attributes  status: 'declined'
        @public_profile_email.update_attributes status: 'declined'
      end

      it 'should redirect to already_answered_path' do
        get :decline, profile_email_id: @user_profile_email
        response.should redirect_to profile_email_already_answered_path
        get :decline, profile_email_id: @other_profile_email
        response.should redirect_to profile_email_already_answered_path
        get :decline, profile_email_id: @public_profile_email
        response.should redirect_to profile_email_already_answered_path
      end

      it 'should not send any email' do
        email = mock Mail::Message
        ProfileEmailMailer.should_not_receive(:decline).with kind_of(ProfileEmail)
        ProfileEmailMailer.should_not_receive(:decline_through_other).with kind_of(ProfileEmail)
        email.should_not_receive(:deliver)
        get :decline, profile_email_id: @user_profile_email
        get :decline, profile_email_id: @other_profile_email
        get :decline, profile_email_id: @public_profile_email
      end
    end

    context "for profile_emails that have not been answered yet" do

      context "and were sent by the user himself" do

        after :each do
          ProfileEmailMailer.deliveries.clear
        end

        it { get :decline, profile_email_id: @user_profile_email ; response.should be_success }

        it 'should update the status' do
          get :decline, profile_email_id: @user_profile_email
          @user_profile_email.reload
          @user_profile_email.status.should == 'declined'
        end

        it 'should send a decline notification email' do
          email = mock Mail::Message
          ProfileEmailMailer.should_receive(:decline).with(kind_of(ProfileEmail)).and_return(email)
          email.should_receive(:deliver)
          get :decline, profile_email_id: @user_profile_email
        end

        it "should send the email to the right user with the right subject" do
          get :decline, profile_email_id: @user_profile_email
          ProfileEmailMailer.deliveries.last.to.should include @author.email
          ProfileEmailMailer.deliveries.last.subject.should == I18n.t('mailers.profile_email.decline.subject', fullname: @user_profile_email.recipient_fullname)
        end

        it 'should have a thank you message' do
          get :decline, profile_email_id: @user_profile_email
          response.body.should have_content I18n.t('profile_emails.decline.thank_you')
        end
      end

      context "and were sent by another user" do

        after :each do
          ProfileEmailMailer.deliveries.clear
        end

        it { get :decline, profile_email_id: @other_profile_email ; response.should be_success }

        it 'should update the status' do
          get :decline, profile_email_id: @other_profile_email
          @other_profile_email.reload
          @other_profile_email.status.should == 'declined'
        end

        it 'should send an other decline notification email' do
          email = mock Mail::Message
          ProfileEmailMailer.should_receive(:decline_through_other).with(kind_of(ProfileEmail)).and_return(email)
          email.should_receive(:deliver)
          get :decline, profile_email_id: @other_profile_email
        end

        it "should send the email to the right user with the right subject" do
          get :decline, profile_email_id: @other_profile_email
          ProfileEmailMailer.deliveries.last.to.should include @author.email
          ProfileEmailMailer.deliveries.last.subject.should == I18n.t('mailers.profile_email.decline_through_other.subject', author_fullname: @other_profile_email.author.fullname, recipient_fullname: @other_profile_email.recipient_fullname)
        end

        it 'should a have thank you message' do
          get :decline, profile_email_id: @other_profile_email
          response.body.should have_content I18n.t('profile_emails.decline.thank_you')
        end
      end

      context "and were sent by a public user"  do

        after :each do
          ProfileEmailMailer.deliveries.clear
        end

        it { get :decline, profile_email_id: @public_profile_email ; response.should be_success }

        it 'should update the status' do
          get :decline, profile_email_id: @public_profile_email
          @public_profile_email.reload
          @public_profile_email.status.should == 'declined'
        end

        it 'should send a decline notification email' do
          email = mock Mail::Message
          ProfileEmailMailer.should_receive(:decline_through_other).with(kind_of(ProfileEmail)).and_return(email)
          email.should_receive(:deliver)
          get :decline, profile_email_id: @public_profile_email
        end

        it "should send the email to the right user with the right subject" do
          get :decline, profile_email_id: @public_profile_email
          ProfileEmailMailer.deliveries.last.to.should include @author.email
          ProfileEmailMailer.deliveries.last.subject.should == I18n.t('mailers.profile_email.decline_through_other.subject', author_fullname: @public_profile_email.author_fullname, recipient_fullname: @public_profile_email.recipient_fullname)
        end

        it 'should a have thank you message' do
          get :decline, profile_email_id: @public_profile_email
          response.body.should have_content I18n.t('profile_emails.decline.thank_you')
        end
      end
    end

    describe "GET 'already_answered'" do

      before :each do
        @author.profiles.create @profile_attr
        @user_profile_email   = ProfileEmail.create!(@profile_email_attr.merge(profile: @author.profile, author: @author,     recipient_email: 'user@example.com', recipient_fullname: 'User Recipient', status: nil))
        @other_profile_email  = ProfileEmail.create!(@profile_email_attr.merge(profile: @author.profile, author: @other_user, recipient_email: 'other_user@example.com', recipient_fullname: 'Other User Recipient', status: nil))
        @public_profile_email = ProfileEmail.create!(@profile_email_attr.merge(profile: @author.profile, author: nil, author_email: @public_user[:email], author_fullname: @public_user[:fullname], recipient_email: 'recipient@example.com', recipient_fullname: 'Public User Recipient', status: nil))
      end

      context 'for profile emails that were sent by the user himself' do

        it { get :already_answered, profile_email_id: @user_profile_email   ; response.should be_success }

        it 'should a have thank you message' do
          get :already_answered, profile_email_id: @user_profile_email
          response.body.should include I18n.t('profile_emails.already_answered.thank_you', fullname: @user_profile_email.profile.user.fullname)
        end
      end

      context 'for profile emails that were sent by another user' do

        it { get :already_answered, profile_email_id: @other_profile_email  ; response.should be_success }

        it 'should a have thank you message' do
          get :already_answered, profile_email_id: @other_profile_email
          response.body.should include I18n.t('profile_emails.already_answered.thank_you', fullname: @other_profile_email.profile.user.fullname)
        end
      end

      context 'for profile emails that were sent by a public user' do

        it { get :already_answered, profile_email_id: @public_profile_email ; response.should be_success }

        it 'should a have thank you message' do
          get :already_answered, profile_email_id: @public_profile_email
          response.body.should include I18n.t('profile_emails.already_answered.thank_you', fullname: @public_profile_email.profile.user.fullname)
        end
      end
    end

    describe "GET 'index'" do

      context 'for public users' do

        it 'should redirect to root_path' do
          get :index
          response.should redirect_to(root_path)
        end

        it 'should have an error message' do
          get :index
          flash[:error].should == I18n.t('flash.error.only.signed_in')
        end
      end

      context 'for signed_in users' do

        before :each do
          sign_in @author
        end

        context 'for users without profile_emails' do

          before :each do
            @author.authored_profile_emails.each(&:destroy)
            get :index
          end

          it 'should redirect to root_path' do
            response.should redirect_to(root_path)
          end

          it 'should have an error message' do
            flash[:error].should == I18n.t('flash.error.profile_email.none')
          end
        end

        context 'for users who have profile_emails' do

          before :each do
            FactoryGirl.create :profile_email, author: @author, profile: @author.profile
            FactoryGirl.create :profile_email, author: @author, profile: @author.profile
            FactoryGirl.create :profile_email, author: @author, profile: @author.profile
            get :index
          end

          it { response.should be_success }

          it 'should have a thumbnail per authored profile_email' do
            @author.authored_profile_emails.each do |pe|
              response.body.should include "thumb-#{pe.id}"
            end
          end

          it 'should have a modal per authored profile_email' do
            @author.authored_profile_emails.each do |pe|
              response.body.should include "modal-#{pe.id}"
            end
          end
        end
      end
    end
  end

  describe "DESTROY 'delete'" do

    before :each do
      sign_in @author
    end

    context "for public users" do

      it 'should redirect to the root path' do
        delete :destroy, id: @profile_email
        response.should redirect_to root_path
        flash[:error].should == I18n.t('flash.error.only.admin')
      end

      it 'should not destroy the profile email' do
        lambda do
          delete :destroy, id: @profile_email
        end.should_not change(ProfileEmail, :count).by 1
      end
    end

    context "for admin users" do

      before :each do
        @author.toggle! :admin
      end

      it 'should destroy the profile email' do
        lambda do
          delete :destroy, id: @profile_email
        end.should change(ProfileEmail, :count).by -1
      end

      it 'should redirect to the admin page' do
        delete :destroy, id: @profile_email
        response.should redirect_to admin_path
        flash[:success].should == I18n.t('flash.success.profile_email.destroyed')
      end
    end
  end
end