class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :slug, index: { unique: true, name: "unique_product_slug" }
      t.text :description
      t.integer :quantity
      t.integer :price
      t.string :unit
      t.decimal :rating
      t.string :image
      t.references :categories, foreign_key: true

      t.timestamps
    end
  end
end
