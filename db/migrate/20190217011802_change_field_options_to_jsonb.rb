class ChangeFieldOptionsToJsonb < ActiveRecord::Migration[5.2]
  def change
    remove_column :attendee_fields, :options, :text
    add_column :attendee_fields, :options, :jsonb
  end
end
