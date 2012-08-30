class EmailSharingsController < ApplicationController

	before_filter :find_user, :only_signed_in, :signed_up, only: :new

  def new
		@email_sharing = EmailSharing.new
	end
end
