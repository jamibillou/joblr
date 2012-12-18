class AddUsedToEmails < ActiveRecord::Migration
  def change
    add_column :emails, :used, :boolean, default: false
  end
end
