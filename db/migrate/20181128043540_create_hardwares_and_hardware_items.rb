class CreateHardwaresAndHardwareItems < ActiveRecord::Migration[5.2]
  def change
    create_table :hardwares do |t|
      t.string :vendor
      t.string :model
      t.integer :quantity
      t.string :slug
      t.references :event, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end

    create_table :hardware_items do |t|
      t.string :checked_out_to
      t.datetime :checked_out_at
      t.references :checked_out_by, foreign_key: { to_table: :users }
      t.references :hardware, foreign_key: true
      t.string :barcode

      t.timestamps
    end
    add_index :hardware_items, :barcode, unique: true
  end
end