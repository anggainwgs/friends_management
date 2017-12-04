class CreateFriends < ActiveRecord::Migration[5.1]
  def change
    create_table :friends do |t|
      t.integer :account_id
      t.integer :friend_account_id

      t.timestamps
    end
    add_index :friends, [:account_id, :friend_account_id], unique: true
  end
end
