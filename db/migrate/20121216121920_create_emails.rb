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
      t.string :text

      t.timestamps
    end
  end
end
