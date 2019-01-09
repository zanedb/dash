class AddWebhooksToEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :webhooks, id: :uuid do |t|
      t.string :name
      t.string :url
      t.string :request_type
      t.references :event, foreign_key: true

      t.timestamps
    end

    remove_column :events, :webhook_post_url, :string
  end
end
