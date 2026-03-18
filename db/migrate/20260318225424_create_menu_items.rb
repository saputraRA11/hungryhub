class CreateMenuItems < ActiveRecord::Migration[8.1]
  def change
    create_table :menu_items do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.string :name, null: false
      t.string :description
      t.float :price, null: false, precision: 10, scale: 2
      t.string :category
      t.boolean :is_available, default: true, null: false

      t.timestamps
    end

    add_index :menu_items, :category
  end
end
