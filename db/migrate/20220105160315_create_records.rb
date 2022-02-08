class CreateRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :records do |t|
      t.references :account, null: false, foreign_key: true
      t.string :recordable_type, null: false
      t.integer :recordable_id, null: false
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.string :title
      t.string :subtitle
      t.text :description

      t.timestamps
    end
    add_index :records, :recordable_id
  end
end
