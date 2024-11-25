class Supplier < ApplicationRecord
  has_many :products
  #   def product
  #     Product.where(supplier_id: id)
  #   end
end
