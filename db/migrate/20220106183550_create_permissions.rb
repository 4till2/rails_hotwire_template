class CreatePermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :permissions do |t|
      t.references :permissionable, polymorphic: true
      t.integer :scope, default: 0
      t.timestamps
    end
  end
end