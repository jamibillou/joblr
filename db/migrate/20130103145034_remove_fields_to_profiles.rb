class RemoveFieldsToProfiles < ActiveRecord::Migration
  def change
  	remove_column :profiles, :headline
  	remove_column :profiles, :text
  end
end
