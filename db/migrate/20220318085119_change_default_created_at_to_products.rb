class ChangeDefaultCreatedAtToProducts < ActiveRecord::Migration[6.0]
  def change
    change_column :products, :created_at, :datetime, default: -> {'CURRENT_TIMESTAMP'}
    change_column :products, :updated_at, :datetime, default: -> {'CURRENT_TIMESTAMP'}
  end
end
