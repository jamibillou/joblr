class DropSharingEmails < ActiveRecord::Migration
  def up
    drop_table :sharing_emails
  end
end
