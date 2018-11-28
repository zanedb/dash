class CreateHardwares < ActiveRecord::Migration[5.2]
  def change
    create_table :hardwares do |t|
      t.string :vendor
      t.string :model
      t.string :checked_out_to
      t.datetime :checked_out_at
      t.references :checked_out_by, foreign_key: { to_table: :users }
      t.string :barcode

      t.timestamps
    end
    add_index :hardwares, :barcode, unique: true
  end
end
