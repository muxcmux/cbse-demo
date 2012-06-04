class AddOverdraftCostToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :overdraft_cost, :decimal, precision: 10, scale: 2
  end
end
