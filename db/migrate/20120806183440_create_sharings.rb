class CreateSharings < ActiveRecord::Migration
  def change
    create_table :sharings do |t|
      t.integer :user_id
      t.string :email
      t.string :fullname
      t.string :company
      t.string :role

      t.timestamps
    end
  end
end
