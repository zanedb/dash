class AddWebhookToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :webhook_post_url, :string
  end
end
