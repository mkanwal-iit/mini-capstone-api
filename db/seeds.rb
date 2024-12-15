# db/seeds.rb

User.create!(name: "Madiha", email: "madiha@email.com", password: "password", admin: true)
User.create(name: "User2", email: "user2@email.com", password: "password")

Supplier.create!(
  [
    { name: "ABC Supplies", email: "contact@abcsupplies.com", phone_number: "555-123-4567" },
    { name: "Tech World", email: "info@techworld.com", phone_number: "555-987-6543" },
    { name: "Global Goods", email: "support@globalgoods.com", phone_number: "555-555-5555" },
  ]
)

# Create Products and assign to variables so we can use their IDs
product1 = Product.create(supplier_id: 1, quantity: 100, name: "Mug", price: 23, description: "Get your morning news once you wake up with a cup of joe from... well Joe. He made it with his homemade duct tape")
product2 = Product.create(supplier_id: 1, quantity: 100, name: "Womens shoes", price: 42, description: "you will feel comfortable.")
product3 = Product.create(supplier_id: 2, quantity: 100, name: "Bag", price: 270, description: "Light weight")
product4 = Product.create(supplier_id: 1, quantity: 100, name: "Perfume", price: 170, description: "You will feel fresh")
product5 = Product.create(supplier_id: 1, quantity: 100, name: "Board_game", price: 57, description: "Best activity for you")
product6 = Product.create(supplier_id: 2, quantity: 100, name: "Screwdriver", price: 9, description: "Fixing tool")
product7 = Product.create(supplier_id: 1, quantity: 100, name: "Yoda sleeping bag", price: 40, description: "For real")

Category.create(name: "Kitchen")
Category.create(name: "Fashion & Lifestyle")
Category.create(name: "Household goods")

CategoryProduct.create(category_id: 1, product_id: 1)
CategoryProduct.create(category_id: 2, product_id: 2)
CategoryProduct.create(category_id: 2, product_id: 3)
CategoryProduct.create(category_id: 2, product_id: 4)
CategoryProduct.create(category_id: 3, product_id: 5)
CategoryProduct.create(category_id: 3, product_id: 6)
CategoryProduct.create(category_id: 3, product_id: 7)

# Create Images associated with Products
Image.create(url: "https://img.freepik.com/premium-photo/cup-coffee-with-cinnamon-sticks-side_265515-6792.jpg", product_id: product1.id, created_at: Time.parse("2024-11-13 17:38:39"), updated_at: Time.parse("2024-11-13 17:38:39"))
Image.create(url: "https://static.nike.com/a/images/c_limit,w_592,f_auto/t_product_v1/f3b2d07b-b041-456e-b7cb-ace423dbc5d0/W+NIKE+COURT+VISION+ALTA.png", product_id: product2.id, created_at: Time.parse("2024-11-13 17:38:39"), updated_at: Time.parse("2024-11-13 17:38:39"))
Image.create(url: "https://img.faballey.com/images/Product/IBG00211/d3.jpg", product_id: product3.id, created_at: Time.parse("2024-11-13 17:38:39"), updated_at: Time.parse("2024-11-13 17:38:39"))
Image.create(url: "https://m.media-amazon.com/images/I/81Ya+gZuZvL._AC_UF1000,1000_QL80_.jpg", product_id: product4.id, created_at: Time.parse("2024-11-13 17:38:39"), updated_at: Time.parse("2024-11-13 17:38:39"))
Image.create(url: "https://m.media-amazon.com/images/I/51WArwbYh6L._AC_.jpg", product_id: product5.id, created_at: Time.parse("2024-11-13 17:38:39"), updated_at: Time.parse("2024-11-13 17:38:39"))
Image.create(url: "https://img.faballey.com/images/Product/IBG00211/d3.jpg", product_id: product3.id, created_at: Time.parse("2024-11-13 17:40:12"), updated_at: Time.parse("2024-11-13 17:40:12"))
Image.create(url: "https://m.media-amazon.com/images/I/51WArwbYh6L._AC_.jpg", product_id: product5.id, created_at: Time.parse("2024-11-13 17:40:12"), updated_at: Time.parse("2024-11-13 17:40:12"))
