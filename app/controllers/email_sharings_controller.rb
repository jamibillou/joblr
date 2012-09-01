class EmailSharingsController < ApplicationController

	before_filter :find_user, :access_to_profile, :signed_up, only: :new

  def new
		@email_sharing = EmailSharing.new
	end
end
