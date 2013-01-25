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
			get :landing
		end

		it { response.should be_success }

		it 'should have the right content' do
			if @version == 'old'
				response.body.should include I18n.t('pages.landing.catchphrase')
				response.body.should include I18n.t('pages.landing.subtitle')
				response.body.should include I18n.t('pages.landing.join')
				response.body.should include I18n.t('pages.landing.benefit1_title')
				response.body.should include I18n.t('pages.landing.benefit1_text')
				response.body.should include I18n.t('pages.landing.benefit2_title')
				response.body.should include I18n.t('pages.landing.benefit2_text')
				response.body.should include I18n.t('pages.landing.benefit3_title')
				response.body.should include I18n.t('pages.landing.benefit3_text_html')
				response.body.should include I18n.t('pages.landing.benefit4_title')
				response.body.should include I18n.t('pages.landing.benefit4_text')
				response.body.should include I18n.t('pages.landing.disclaimer_html')
			else
				# TO DO!
			end
		end

		it 'should have mixpanel event' do
			response.body.should match /mixpanel.track\('Viewed landing page', {'Landing version': '(old|new)'/
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