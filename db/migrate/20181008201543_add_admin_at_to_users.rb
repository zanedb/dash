class AddAdminAtToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admin_at, :datetime
  end
end
