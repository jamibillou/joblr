require 'spec_helper'

describe PagesController do

	render_views

	before :each do
		@user  = FactoryGirl.create :user
		@admin = FactoryGirl.create :user, fullname: FactoryGirl.generate(:fullname), username: FactoryGirl.generate(:username), email: FactoryGirl.generate(:email), admin: true
	end

	describe "GET 'landing'" do

		before :each do
			get :landing
		end	

		it { response.should be_success }

		it 'should contain a motto' do
			response.body.should include I18n.t('pages.landing.motto')
		end
	end

	describe "GET 'admin'" do

		context 'for public users' do

			before :each do
				get :admin
			end

			it 'should redirect to root path' do
				response.should redirect_to(root_path)
				flash[:error].should == I18n.t('flash.error.only.admin')
			end
		end	

		context 'for standard users' do
			before :each do
				sign_in @user
				get :admin
			end

			it 'should redirect to root path' do
				response.should redirect_to(root_path)
				flash[:error].should == I18n.t('flash.error.only.admin')
			end
		end

		context 'for admins' do
			before :each do
				sign_in @admin
				get :admin
			end

			it { response.should be_success }

			it 'should have a div with the class admin' do
				response.body.should have_selector 'div.admin'
			end
		end
	end

	describe "GET 'style tile'" do

		context 'for public users' do

			before :each do
				get :style_tile
			end

			it 'should redirect to root path' do
				response.should redirect_to(root_path)
				flash[:error].should == I18n.t('flash.error.only.admin')
			end
		end	

		context 'for standard users' do
			before :each do
				sign_in @user
				get :style_tile
			end

			it 'should redirect to root path' do
				response.should redirect_to(root_path)
				flash[:error].should == I18n.t('flash.error.only.admin')
			end
		end

		context 'for admins' do
			before :each do
				sign_in @admin
				get :style_tile
			end

			it { response.should be_success }

			it 'should have a div with the class admin' do
				response.body.should include 'Main typography'
			end
		end
	end
end