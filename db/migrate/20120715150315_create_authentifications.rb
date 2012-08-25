class CreateAuthentifications < ActiveRecord::Migration
  def change
    create_table :authentifications do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.string :uname
      t.string :uemail
      t.string :url
      t.string :utoken
      t.string :usecret

      t.timestamps
    end
  end
end
