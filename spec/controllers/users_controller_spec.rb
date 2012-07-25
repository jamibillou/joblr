require 'spec_helper'

describe UsersController do

  render_views

  before :each do
    @user = FactoryGirl.create :user
    sign_in @user
    @attr = { fullname: 'Tony Leung', city: 'Hong Kong', country: 'China', role: 'Mole', company: 'HK triads',
              profiles_attributes: { '0' => { experience: '10', education: 'none', text: 'A good and highly motivated guy.' } } }
  end

  describe "GET 'edit'" do

    before :each do
      get :edit, id: @user
    end

    it { response.should be_success }

    it 'should have an edit form' do
      response.body.should have_selector 'form', class: 'edit_user', id: 'edit_form'
    end
  end

  describe "PUT 'update" do

    it 'should update the user' do
      put :update, user: @attr, id: @user
      updated_user = assigns :user
      @user.reload
      @user.fullname.should == updated_user.fullname
    end

    it 'should not create a new user' do
      lambda do
        put :update, user: @attr, id: @user
      end.should_not change(User, :count)
    end

    it 'should create a profile' do
      lambda do
        put :update, user: @attr, id: @user
      end.should change(Profile, :count).by(1)
    end

    it "should redirect to the 'show' page" do
      put :update, user: @attr, id: @user
      response.should redirect_to @user
    end
  end
end