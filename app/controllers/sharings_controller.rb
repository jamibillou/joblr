class SharingsController < ApplicationController

	def new
		@user = User.find(params[:id])
		@sharing = Sharing.new
	end
end
