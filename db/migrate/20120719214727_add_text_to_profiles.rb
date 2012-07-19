class AddTextToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :text, :string
  end
end
