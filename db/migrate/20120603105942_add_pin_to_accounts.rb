class AddPinToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :pin, :integer, limit: 4
  end
end
