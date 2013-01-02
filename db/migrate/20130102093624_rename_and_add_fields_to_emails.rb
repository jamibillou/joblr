class RenameAndAddFieldsToEmails < ActiveRecord::Migration
  def change
    rename_column :emails, :email, :recipient_email
    rename_column :emails, :user_id, :recipient_id
    add_column :emails, :author_fullname, :string
    add_column :emails, :author_email, :string
    add_column :emails, :recipient_fullname, :string
    add_column :emails, :cc, :string
    add_column :emails, :bcc, :string
    add_column :emails, :reply_to, :string
    add_column :emails, :subject, :string
    add_column :emails, :status, :string
    add_column :emails, :type, :string
    add_column :emails, :page, :string
    add_column :emails, :text, :string
    add_column :emails, :used, :boolean, :default => false
    add_column :emails, :profile_id, :integer
    add_column :emails, :author_id, :integer
  end
end
