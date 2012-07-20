class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :city, :string
    add_column :users, :country, :string
    add_column :users, :role, :string
    add_column :users, :company, :string
  end
end
