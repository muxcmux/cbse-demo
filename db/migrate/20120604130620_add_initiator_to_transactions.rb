class AddInitiatorToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :initiator, :string
  end
end
