class AddTokenAndSecretToAuthentifications < ActiveRecord::Migration
  def change
    add_column :authentifications, :utoken, :string
    add_column :authentifications, :usecret, :string
  end
end
