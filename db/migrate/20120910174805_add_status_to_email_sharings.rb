class AddStatusToEmailSharings < ActiveRecord::Migration
  def change
    add_column :email_sharings, :status, :string
  end
end
