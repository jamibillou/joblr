class RenameAuthentifications < ActiveRecord::Migration
  def change
    rename_table :authentifications, :authentications
  end
end
