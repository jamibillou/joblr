class AddSocialToUsers < ActiveRecord::Migration
  def change
    add_column :users, :social, :boolean, :default => false
  end
end
