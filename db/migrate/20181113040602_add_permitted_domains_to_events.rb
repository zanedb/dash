class AddPermittedDomainsToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :permitted_domains, :string
  end
end
