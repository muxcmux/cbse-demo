class AddBalanceToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :balance, :decimal, precision: 10, scale: 2
  end
end
