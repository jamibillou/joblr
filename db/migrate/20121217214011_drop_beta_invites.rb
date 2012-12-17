class DropBetaInvites < ActiveRecord::Migration
  def change
    drop_table :beta_invites
  end
end
