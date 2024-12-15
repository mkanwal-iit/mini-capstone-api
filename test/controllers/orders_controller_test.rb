require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(name: "Test", email: "test@test.com", password: "password")
    @order = Order.create(user_id: @user.id)
    post "/sessions.json", params: { email: "test@test.com", password: "password" }
  end

  test "index" do
    get "/orders.json"
    assert_response 200
  end

  test "create" do
    assert_difference "Order.count", 1 do
      post "/orders.json",
        params: { product_id: Product.first.id, quantity: 10 }
      assert_response 200
    end
  end

  test "show" do
    get "/orders/#{@order.id}.json"
    assert_response 200

    data = JSON.parse(response.body)
    assert_equal ["id", "subtotal", "tax", "total", "carted_products", "created_at", "updated_at"], data.keys
  end
end
