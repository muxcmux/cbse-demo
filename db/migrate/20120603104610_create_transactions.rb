class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :account
      t.decimal :amount, precision: 10, scale: 2
      t.string :transaction_type

      t.timestamps
    end
    add_index :transactions, :account_id
  end
end
