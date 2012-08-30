class CreateEmailSharings < ActiveRecord::Migration
  def change
    create_table :email_sharings do |t|
      t.integer :profile_id
      t.integer :author_id
      t.string :author_fullname
      t.string :author_email
      t.string :recipient_fullname
      t.string :recipient_email
      t.string :text

      t.timestamps
    end
  end
end
