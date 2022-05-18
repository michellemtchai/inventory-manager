class CreateInventoryItems < ActiveRecord::Migration[7.0]
  def change
    create_table :inventory_items do |t|
      t.references :product, null: false, foreign_key: true
      t.references :city, null: false, foreign_key: true
      t.integer :count

      t.timestamps
    end
  end
end
