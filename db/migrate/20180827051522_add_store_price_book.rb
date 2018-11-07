class AddStorePriceBook < ActiveRecord::Migration[4.2]
  def change
    remove_column :spree_price_books, :store_id
    remove_index :spree_price_books, :store_id
  end
end
