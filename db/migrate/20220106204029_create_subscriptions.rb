class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.references :subscriber, null: false, foreign_key: { to_table: :accounts }
      t.references :subscribable, polymorphic: true

      t.timestamps

      t.index %i[subscribable_type subscribable_id subscriber_id], name: :index_subscription_uniqueness, unique: true
    end
  end
end
