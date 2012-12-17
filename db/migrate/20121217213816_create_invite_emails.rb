class CreateInviteEmails < ActiveRecord::Migration
  def change
    create_table :invite_emails do |t|
      t.integer :user_id
      t.string  :code
      t.string  :email
      t.boolean :sent, :default => false

      t.timestamps
    end
  end
end
