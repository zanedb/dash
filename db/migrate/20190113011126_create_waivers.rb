class CreateWaivers < ActiveRecord::Migration[5.2]
  def change
    create_table :waivers, id: :uuid do |t|
      t.boolean :require_signed_before_checkin
      t.references :event, foreign_key: true

      t.timestamps
    end
  end
end
