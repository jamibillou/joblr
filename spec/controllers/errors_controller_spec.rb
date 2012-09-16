require 'spec_helper'

describe ErrorsController do

	render_views

	describe "get '/404'" do

		before :each do
			visit '/404'
		end

		it { response.should be_success }

		it 'should have error text' do
			page.should have_content I18n.t('errors.error_404.title')
			page.should have_content I18n.t('errors.error_404.content')
		end
	end

	describe "get '/422'" do

		before :each do
			visit '/422'
		end

		it { response.should be_success }

		it 'should have error text' do
			page.should have_content I18n.t('errors.error_422.title')
			page.should have_content I18n.t('errors.error_422.content')
		end
	end

	describe "get '/500'" do

		before :each do
			visit '/500'
		end

		it { response.should be_success }

		it 'should have error text' do
			page.should have_content I18n.t('errors.error_500.title')
      page.should have_content I18n.t('errors.error_500.content')
		end
	end
end