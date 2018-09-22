class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :startDate
      t.datetime :endDate
      t.text :location

      t.timestamps
    end
  end
end
