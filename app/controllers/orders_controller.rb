class OrdersController < ApplicationController
  before_action :authenticate_user

  def create
    carted_products = CartedProduct.where(user_id: current_user.id, status: "carted")
    calculated_subtotal = 0
    calculated_tax = 0
    carted_products.each do |carted_product|
      calculated_subtotal += carted_product.quantity * carted_product.product.price
      calculated_tax += carted_product.quantity * carted_product.product.tax
    end

    calculated_total = calculated_subtotal + calculated_tax
    @order = Order.create(
      user_id: current_user.id,
      subtotal: calculated_subtotal,
      tax: calculated_tax,
      total: calculated_total,
    )
    carted_products.each do |carted_product|
      carted_product.update(status: "purchased", order_id: @order.id)
    end
    render :show
  end

  # GET /orders/:id
  def show
    @order = current_user.orders.find_by(id: params[:id]) # or Order.find_by(id: params[:id], user_id: current_user.id)
    render :show
  end

  # GET /orders
  def index
    @orders = current_user.orders # or Order.where(user_id: current_user.id)
    render :index
  end
end
