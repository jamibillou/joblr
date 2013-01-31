require 'spec_helper'

describe PagesController do

	render_views

	before :each do
		@user    = FactoryGirl.create :user
		@admin   = FactoryGirl.create :user, fullname: FactoryGirl.generate(:fullname), username: FactoryGirl.generate(:username), email: FactoryGirl.generate(:email), admin: true
		@profile = FactoryGirl.create :profile, user: @user
	end

	describe "GET 'landing'" do

		before :each do
			get :landing, landing_version: 'fourth'
		end

		it { response.should be_success }

		it 'should have the right content' do
		  get :landing, landing_version: 'old'
			response.body.should have_content I18n.t('pages.landing.old.catchphrase')
			response.body.should have_content I18n.t('pages.landing.old.subtitle')
			response.body.should have_content I18n.t('pages.landing.old.signup')
			response.body.should have_content I18n.t('pages.landing.old.benefit1_title')
			response.body.should have_content I18n.t('pages.landing.old.benefit1_text')
			response.body.should have_content I18n.t('pages.landing.old.benefit2_title')
			response.body.should have_content I18n.t('pages.landing.old.benefit2_text')
			response.body.should have_content I18n.t('pages.landing.old.benefit3_title')
			response.body.should have_content I18n.t('pages.landing.old.benefit3_text_html')
			response.body.should have_content I18n.t('pages.landing.old.benefit4_title')
			response.body.should have_content I18n.t('pages.landing.old.benefit4_text')
		end
		it 'should have the right content' do
			get :landing, landing_version: 'new'
			response.body.should have_content I18n.t('pages.landing.new.title')
			response.body.should have_content I18n.t('pages.landing.new.signup')
			response.body.should have_selector '#modal_signup'
			response.body.should have_selector '#modal_profile'
			response.body.should have_selector '#modal_apply'
			response.body.should have_selector '#modal_applications'
		end
		it 'should have the right content' do
			get :landing, landing_version: 'fourth'
			response.body.should have_content I18n.t('pages.landing.fourth.title', link: I18n.t('pages.landing.fourth.click'))
			response.body.should have_content I18n.t('pages.landing.fourth.signup')
			response.body.should have_content I18n.t('pages.landing.fourth.catchphrase')
			response.body.should have_content I18n.t('pages.landing.fourth.subtitle')
			response.body.should have_content I18n.t('pages.landing.fourth.signup')
			response.body.should have_content I18n.t('pages.landing.fourth.benefit1_title')
			response.body.should have_content I18n.t('pages.landing.fourth.benefit1_text')
			response.body.should have_content I18n.t('pages.landing.fourth.benefit2_title')
			response.body.should have_content I18n.t('pages.landing.fourth.benefit2_text')
			response.body.should have_content I18n.t('pages.landing.fourth.benefit3_title')
			response.body.should have_content I18n.t('pages.landing.fourth.benefit3_text_html')
			response.body.should have_content I18n.t('pages.landing.fourth.benefit4_title')
			response.body.should have_content I18n.t('pages.landing.fourth.benefit4_text')
		end

		it 'should have the right mixpanel event' do
			if @version == 'old'
			  response.body.should have_content "mixpanel.track('Viewed landing page', {'Landing version': 'old'})"
			elsif @version == 'new'
				response.body.should have_content "mixpanel.track('Viewed landing page', {'Landing version': 'new'})"
			elsif @version == 'fourth'
				response.body.should have_content "mixpanel.track('Viewed landing page', {'Landing version': 'fourth'})"
			end
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

		context 'for signed in users' do

			context 'who are not admin' do

				before :each do
					sign_in @user
					get :admin
				end

				it 'should redirect to root path' do
					response.should redirect_to(root_path)
					flash[:error].should == I18n.t('flash.error.only.admin')
				end
			end

			context 'who are admin' do

				before :each do
					sign_in @admin
					get :admin
				end

				it { response.should be_success }

				it 'should have an admin block' do
					response.body.should have_selector 'div#admin'
				end
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

		context 'for signed in users' do

			context 'who are not admin' do

				before :each do
					sign_in @user
					get :style_tile
				end

				it 'should redirect to root path' do
					response.should redirect_to(root_path)
					flash[:error].should == I18n.t('flash.error.only.admin')
				end
		  end

			context 'who are admin' do

				before :each do
					sign_in @admin
					get :style_tile
				end

				it { response.should be_success }

				it 'should have a style_tile block' do
					response.body.should have_selector 'div#style-tile'
				end
			end
		end
	end

	describe "GET 'sign_up'" do

		context 'for public users' do

			before :each do
				get :sign_up
			end

			it { response.should be_success }

			it 'should have a LinkedIn button' do
				response.body.should have_selector 'a.btn-linkedin'
			end

			it 'should have a Twitter button' do
				response.body.should have_selector 'a.btn-twitter'
			end

			it 'should have a Facebook button' do
				response.body.should have_selector 'a.btn-facebook'
			end

			it 'should have a Google button' do
				response.body.should have_selector 'a.btn-google'
			end

			it 'should have a no-worries block' do
				response.body.should have_selector 'div.no-worries'
			end

			it 'should have a manual signup link' do
				response.body.should have_content I18n.t('pages.sign_up.manual')
			end

			it 'should have the right mixpanel event' do
				response.body.should have_content "mixpanel.track('Clicked Signup button')"
			end
		end

		context 'for signed in users' do
			before :each do
				sign_in @user
				get :sign_up
			end

			it 'should redirect to root path' do
				response.should redirect_to(root_path)
				flash[:error].should == I18n.t('flash.error.only.public')
			end
		end
	end
end