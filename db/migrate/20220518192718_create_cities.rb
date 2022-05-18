class CreateCities < ActiveRecord::Migration[7.0]
  def change
    create_table :cities do |t|
      t.string :name
      t.string :region, null: true
      t.references :country, null: false, foreign_key: true
      t.float :lat
      t.float :long

      t.timestamps
    end
  end
end
