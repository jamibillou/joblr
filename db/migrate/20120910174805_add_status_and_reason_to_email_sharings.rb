class AddStatusAndReasonToEmailSharings < ActiveRecord::Migration
  def change
    add_column :email_sharings, :status, :string
    add_column :email_sharings, :reason, :string
  end
end
