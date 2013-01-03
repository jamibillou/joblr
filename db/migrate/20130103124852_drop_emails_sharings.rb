class DropEmailsSharings < ActiveRecord::Migration
	def up
		drop_table :email_sharings
	end
end
