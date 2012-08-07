class CreateSharings < ActiveRecord::Migration
  def change
    create_table :sharings do |t|
      t.integer :author_id
      t.integer :recipient_id
      t.string  :text

      t.timestamps
    end
  end
end
