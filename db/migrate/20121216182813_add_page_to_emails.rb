class AddPageToEmails < ActiveRecord::Migration
  def change
    add_column :emails, :page, :string
  end
end
