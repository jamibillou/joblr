class AddUthumbToAuthentifications < ActiveRecord::Migration
  def change
    add_column :authentifications, :uthumb, :string
  end
end
