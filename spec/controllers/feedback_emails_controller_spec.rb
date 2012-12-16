require 'spec_helper'

describe FeedbackEmailsController do

  render_views

  before :each do
    @user = FactoryGirl.create :user
    @attr  = { author_id: @user.id, recipient_fullname: 'Joblr team', recipient_email: 'team@joblr.co', text: 'Lorem ipsum', page: '/' }
  end

  describe "POST 'create'" do

    before :each do
      sign_in @user
    end

    context 'blank text submitted' do

      it 'should not create a new feedback_email object' do
        lambda do
          xhr :post, :create, feedback_email: @attr.merge(text: '')
        end.should_not change(FeedbackEmail, :count).by 1
      end

      # it "should not send the feedback by email" do
      #   email = mock Mail::Message
      #   FeedbackEmailMailer.should_not_receive(:footer_form).with(kind_of(FeedbackEmail), kind_of(User)).and_return(email)
      #   email.should_not_receive(:deliver)
      #   xhr :post, :create, feedback_email: @attr.merge(text: '')
      # end

      it 'should have an error messsage' do
        xhr :post, :create, feedback_email: @attr.merge(text: '')
        response.body.should == "#{I18n.t('activerecord.attributes.feedback_email.text')} #{I18n.t('activerecord.errors.messages.blank')}."
      end
    end

    it 'should create a new feedback_email object' do
      lambda do
        xhr :post, :create, feedback_email: @attr
      end.should change(FeedbackEmail, :count).by 1
    end

    # it "should not send the feedback by email" do
    #   email = mock Mail::Message
    #   FeedbackEmailMailer.should_receive(:footer_form).with(kind_of(FeedbackEmail), kind_of(User)).and_return(email)
    #   email.should_receive(:deliver)
    #   xhr :post, :create, feedback_email: @attr
    # end

    it 'should have a success messsage' do
      xhr :post, :create, feedback_email: @attr
      response.body.should == 'Thank you!'
    end
  end
end
