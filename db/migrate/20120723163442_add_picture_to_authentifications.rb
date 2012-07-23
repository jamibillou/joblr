class AddPictureToAuthentifications < ActiveRecord::Migration
  def change
    add_column :authentifications, :upic, :string
  end
end
