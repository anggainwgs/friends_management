class CreateSubscribes < ActiveRecord::Migration[5.1]
  def change
    create_table :subscribes do |t|
      t.integer :account_id
      t.integer :request_account_id
      t.boolean :block, default: false

      t.timestamps
    end
    add_index :subscribes, :account_id
    add_index :subscribes, :request_account_id
  end
end
