require 'spec_helper'

describe UsersController do

  render_views

  before :each do
    @user = FactoryGirl.create :user
    sign_in @user
    @attr = { fullname: 'Tony Leung', city: 'Hong Kong', country: 'China', role: 'Mole', company: 'HK triads',
              profiles_attributes: { '0' => { experience: '10', education: 'none', text: 'A good and highly motivated guy.' } } }
    @profile_attr = { education: 'Master of Business Administration',
                      experience: '5 yrs',
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
  end

  describe "GEt 'show'" do

    context "user hasn't completed his profile" do

      it "should redirect to 'edit'" do
        get :show, id: @user
        response.should redirect_to edit_user_path(@user)
      end
    end

    context 'user has completed his profile' do

      before :each do
        @user.profiles.create @profile_attr
        get :show, id: @user
      end

      it { response.should be_success }

      it 'should have a user profile' do
      response.body.should have_selector 'div', class:'card', id:"show-user-#{@user.id}"
    end
    end
  end

  describe "GET 'edit'" do

    before :each do
      get :edit, id: @user
    end

    it { response.should be_success }

    it 'should have an edit form' do
      response.body.should have_selector 'form', class:'edit_user', id:"edit-user-#{@user.id}"
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