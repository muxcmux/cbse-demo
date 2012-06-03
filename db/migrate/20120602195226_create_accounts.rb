class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :user
      t.string :name
      t.string :number
      t.decimal :balance, precision: 10, scale: 2

      t.timestamps
    end
    add_index :accounts, :user_id
    add_index :accounts, :number, unique: true
  end
end
