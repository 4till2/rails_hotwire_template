class CreateLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :links do |t|
      t.string :_type, default: 'external'
      t.string :url
      t.jsonb :fields, default: { embed: true, new_tab: false }

      t.timestamps
    end
  end
end
