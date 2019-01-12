class CreateRegistrationConfig < ActiveRecord::Migration[5.2]
  def change
    create_table :registration_configs, id: :uuid do |t|
      t.integer :goal
      t.datetime :open_at
      t.boolean :api_enabled
      t.belongs_to :event, index: true

      t.timestamps
    end
  end
end
