class RenameBetaInvites < ActiveRecord::Migration
  def change
    rename_table :beta_invites, :emails
  end
end
