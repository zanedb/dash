class RemoveUselessThing < ActiveRecord::Migration[5.2]
  def change
    remove_column :waivers, :require_signed_before_checkin, :boolean
  end
end
