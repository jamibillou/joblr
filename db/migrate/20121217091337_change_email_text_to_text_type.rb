class ChangeEmailTextToTextType < ActiveRecord::Migration
  def change
    change_column :emails, :text, :text
  end
end
