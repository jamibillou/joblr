class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :author_fullname
      t.string :author_email
      t.string :recipient_fullname
      t.string :recipient_email
      t.string :cc
      t.string :bcc
      t.string :subject
      t.string :status
      t.string :type
      t.string :page
      t.string :code
      t.text   :text
      t.boolean :sent, :default => false
      t.boolean :used, :default => false
      t.integer :profile_id
      t.integer :author_id
      t.integer :recipient_id
      t.timestamps
    end
  end
end
