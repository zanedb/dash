class CreateEmailConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :email_configs do |t|
      t.string :smtp_url
      t.string :smtp_port
      t.string :authentication
      t.string :domain
      t.string :sender_email
      t.string :username
      t.string :password
      t.belongs_to :event, index: true

      t.timestamps
    end
  end
end
