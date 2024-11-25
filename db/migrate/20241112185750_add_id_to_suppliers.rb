class AddIdToSuppliers < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :supplier_id, :integer
  end
end
