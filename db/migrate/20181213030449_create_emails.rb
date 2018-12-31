class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.string :recipient
      t.string :sender_email
      t.text :subject
      t.text :body
      t.string :read_receipt_img_url
      t.string :read_receipt_stats_url
      t.belongs_to :event, index: true

      t.timestamps
    end
  end
end
