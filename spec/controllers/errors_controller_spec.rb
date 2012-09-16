require 'spec_helper'

describe ErrorsController do

	render_views

	describe "404" do

		it { visit '/404' ; response.should be_success }

		it 'should have error text' do
			visit '/404'
			page.should have_content I18n.t('errors.error_404.title')
			page.should have_content I18n.t('errors.error_404.content')
		end

		it 'should be rendered for routing errors' do
			expect { get '/bla' }.to raise_error(ActionController::RoutingError)
      response.should render_template(controller: 'errors', action: 'error_404')
    end

    it 'should be rendered for unknown controllers' do
    	expect { raise ActionController::UnknownController }.to raise_error(ActionController::UnknownController)
      response.should render_template(controller: 'errors', action: 'error_404')
    end

    it 'should be rendered for unkown actions' do
	    expect { raise ActionController::UnknownAction }.to raise_error(ActionController::UnknownAction)
      response.should render_template(controller: 'errors', action: 'error_404')
    end

    it 'should be rendered for not found records' do
    	expect { raise ActiveRecord::RecordNotFound }.to raise_error(ActiveRecord::RecordNotFound)
      response.should render_template(controller: 'errors', action: 'error_404')
    end
	end

	describe "422" do

		it { visit '/422' ; response.should be_success }

		it 'should have error text' do
			visit '/422'
			page.should have_content I18n.t('errors.error_422.title')
			page.should have_content I18n.t('errors.error_422.content')
		end
	end

	describe "500" do

		it { visit '/500' ; response.should be_success }

		it 'should have error text' do
			visit '/500'
			page.should have_content I18n.t('errors.error_500.title')
      page.should have_content I18n.t('errors.error_500.content')
		end

		it 'should be rendered for exceptions' do
      expect { raise 'bla' }.to raise_error(Exception)
      response.should render_template(controller: 'errors', action: 'error_500')
    end
	end
end