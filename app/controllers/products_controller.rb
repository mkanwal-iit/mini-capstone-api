class ProductsController < ApplicationController
  def one_product
    @product = Product.first
    render template: "api/products/show"
  end

  def all_products
    @products = Product.all
    render template: "api/products/index"
  end
end
