class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, index: { unique: true, name: "unique_email" }
      t.string :avatar
      t.string :password_digest
      t.boolean :activated, default: false
      t.string :activated_digest
      t.integer :role, default: 0
      t.string :reset_digest
      t.datetime :reset_expire_at
      t.string :session_digest

      t.timestamps
    end
  end
end
