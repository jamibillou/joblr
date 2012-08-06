class AddTextToSharings < ActiveRecord::Migration
  def change
    add_column :sharings, :text, :string
  end
end
