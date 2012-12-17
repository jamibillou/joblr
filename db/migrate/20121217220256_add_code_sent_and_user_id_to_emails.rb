class AddCodeSentAndUserIdToEmails < ActiveRecord::Migration
  def change
    add_column :emails, :code, :string
    add_column :emails, :user_id, :integer
    add_column :emails, :sent, :boolean, :default => false
  end
end
