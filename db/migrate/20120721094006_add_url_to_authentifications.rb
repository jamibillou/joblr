class AddUrlToAuthentifications < ActiveRecord::Migration
  def change
    add_column :authentifications, :url, :string
  end
end
