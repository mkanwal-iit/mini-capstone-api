# db/seeds.rb
#
# Idempotent: find_or_create_by! looks for an existing row before inserting, so
# this can run on every container boot without duplicating data or raising on a
# uniqueness validation.
#
# Associations are resolved through the objects themselves rather than hardcoded
# ids, which only line up on a freshly created database.

admin = User.find_or_create_by!(email: "madiha@email.com") do |user|
  user.name = "Madiha"
  user.password = "password"
  user.admin = true
end

User.find_or_create_by!(email: "user2@email.com") do |user|
  user.name = "User2"
  user.password = "password"
end

abc = Supplier.find_or_create_by!(name: "ABC Supplies") do |supplier|
  supplier.email = "contact@abcsupplies.com"
  supplier.phone_number = "555-123-4567"
end

tech_world = Supplier.find_or_create_by!(name: "Tech World") do |supplier|
  supplier.email = "info@techworld.com"
  supplier.phone_number = "555-987-6543"
end

Supplier.find_or_create_by!(name: "Global Goods") do |supplier|
  supplier.email = "support@globalgoods.com"
  supplier.phone_number = "555-555-5555"
end

kitchen = Category.find_or_create_by!(name: "Kitchen")
fashion = Category.find_or_create_by!(name: "Fashion & Lifestyle")
household = Category.find_or_create_by!(name: "Household goods")

CATALOGUE = [
  {
    name: "Mug",
    price: 23,
    supplier: :abc,
    category: :kitchen,
    description: "Get your morning news once you wake up with a cup of joe from... well Joe. He made it with his homemade duct tape",
    image: "https://img.freepik.com/premium-photo/cup-coffee-with-cinnamon-sticks-side_265515-6792.jpg"
  },
  {
    name: "Womens shoes",
    price: 42,
    supplier: :abc,
    category: :fashion,
    description: "you will feel comfortable.",
    image: "https://static.nike.com/a/images/c_limit,w_592,f_auto/t_product_v1/f3b2d07b-b041-456e-b7cb-ace423dbc5d0/W+NIKE+COURT+VISION+ALTA.png"
  },
  {
    name: "Bag",
    price: 270,
    supplier: :tech_world,
    category: :fashion,
    description: "Light weight",
    image: "https://img.faballey.com/images/Product/IBG00211/d3.jpg"
  },
  {
    name: "Perfume",
    price: 170,
    supplier: :abc,
    category: :fashion,
    description: "You will feel fresh",
    image: "https://m.media-amazon.com/images/I/81Ya+gZuZvL._AC_UF1000,1000_QL80_.jpg"
  },
  {
    name: "Board_game",
    price: 57,
    supplier: :abc,
    category: :household,
    description: "Best activity for you",
    image: "https://m.media-amazon.com/images/I/51WArwbYh6L._AC_.jpg"
  },
  {
    name: "Screwdriver",
    price: 9,
    supplier: :tech_world,
    category: :household,
    description: "Fixing tool",
    image: "https://m.media-amazon.com/images/I/61zFhBqWTOL._AC_UF1000,1000_QL80_.jpg"
  },
  {
    name: "Yoda sleeping bag",
    price: 40,
    supplier: :abc,
    category: :household,
    description: "For real",
    image: "https://m.media-amazon.com/images/I/71ZQFBKxLRL._AC_UF1000,1000_QL80_.jpg"
  }
].freeze

SUPPLIERS = { abc: abc, tech_world: tech_world }.freeze
CATEGORIES = { kitchen: kitchen, fashion: fashion, household: household }.freeze

CATALOGUE.each do |attrs|
  product = Product.find_or_create_by!(name: attrs[:name]) do |record|
    record.supplier_id = SUPPLIERS.fetch(attrs[:supplier]).id
    record.quantity = 100
    record.price = attrs[:price]
    record.description = attrs[:description]
  end

  CategoryProduct.find_or_create_by!(
    category_id: CATEGORIES.fetch(attrs[:category]).id,
    product_id: product.id
  )

  Image.find_or_create_by!(url: attrs[:image], product_id: product.id)
end

puts "Seeded #{User.count} users, #{Supplier.count} suppliers, " \
     "#{Category.count} categories, #{Product.count} products, " \
     "#{Image.count} images."
