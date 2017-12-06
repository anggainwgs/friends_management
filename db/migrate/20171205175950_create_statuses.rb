class CreateStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :statuses do |t|
      t.integer :account_id
      t.text :text
      t.string :recipient_ids

      t.timestamps
    end
    add_index :statuses, :account_id
  end
end
