class ChangeCategoryFkNameInProduct < ActiveRecord::Migration[6.0]
  def change
    rename_column :products, :categories_id, :category_id
  end
end
