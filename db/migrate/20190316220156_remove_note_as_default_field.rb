class RemoveNoteAsDefaultField < ActiveRecord::Migration[5.2]
  def change
    remove_column :attendees, :note, :text
  end
end
