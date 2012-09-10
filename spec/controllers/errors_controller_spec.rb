require 'spec_helper'

describe ErrorsController do

	render_views

	describe '404 Error' do

		before :each do
			get :error_404
		end	

		it { response.should be_success }

		it 'should have error text' do
			response.body.should include I18n.t('errors.error_404.title')
		end
	end

	describe '500 Error' do

		before :each do
			get :error_500
		end	

		it { response.should be_success }

		it 'should have error text' do
			response.body.should include I18n.t('errors.error_500.title',)
		end	
	end	
end