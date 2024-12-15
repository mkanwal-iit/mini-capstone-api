class RemoveProductIdAndQuantityFromOrders < ActiveRecord::Migration[8.0]
  def change
    remove_column :orders, :product_id, :integer
    remove_column :orders, :quantity, :integer
  end
end
