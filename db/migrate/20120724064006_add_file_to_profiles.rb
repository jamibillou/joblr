class AddFileToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :file, :string
  end
end
