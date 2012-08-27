class AddSentToBetaInvites < ActiveRecord::Migration
  def change
    add_column :beta_invites, :sent, :boolean, :default => false
  end
end
