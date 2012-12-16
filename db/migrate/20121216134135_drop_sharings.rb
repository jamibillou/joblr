class DropSharings < ActiveRecord::Migration
  def up
    drop_table :sharings
  end
end
