class AddStatusToSharingEmails < ActiveRecord::Migration
  def change
    add_column :sharing_emails, :status, :string
  end
end
