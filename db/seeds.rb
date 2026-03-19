require "faker"

puts "Clearing existing data..."
MenuItem.destroy_all
Restaurant.destroy_all
User.destroy_all

puts "Creating seed user..."
User.create!(
  email: "admin@hungryhub.com",
  password: "password123"
)

puts "Creating restaurants and menu items..."

mango_grove = Restaurant.create!(
  name: "Mango Grove",
  address: "88 Sukhumvit Soi 11, Bangkok 10110",
  phone: "+66-2-123-4567",
  opening_hours: "Mon–Sun 11:00–22:00"
)

bangkok_bites = Restaurant.create!(
  name: "Bangkok Bites",
  address: "42 Silom Road, Bang Rak, Bangkok 10500",
  phone: "+66-2-987-6543",
  opening_hours: "Mon–Fri 10:00–21:00, Sat–Sun 11:00–23:00"
)

# --- Mango Grove menu ---
[
  { name: "Spring Rolls",        description: "Crispy vegetable spring rolls with sweet chili dip",  price: 120,  category: "appetizer" },
  { name: "Tom Yum Goong",       description: "Classic spicy shrimp soup with lemongrass and lime",  price: 280,  category: "main" },
  { name: "Pad Thai",            description: "Stir-fried rice noodles with egg, peanuts, and lime", price: 220,  category: "main" },
  { name: "Mango Sticky Rice",   description: "Sweet glutinous rice with fresh mango and coconut milk", price: 150, category: "dessert" },
  { name: "Thai Iced Tea",       description: "Strong brewed tea with condensed milk over ice",      price: 80,   category: "drink" }
].each { |attrs| mango_grove.menu_items.create!(attrs) }

# --- Bangkok Bites menu ---
[
  { name: "Satay Skewers",       description: "Grilled chicken skewers with peanut sauce",           price: 160,  category: "appetizer" },
  { name: "Green Curry",         description: "Aromatic green curry with coconut milk and vegetables", price: 260, category: "main" },
  { name: "Massaman Beef",       description: "Slow-cooked beef in rich Massaman curry",             price: 320,  category: "main" },
  { name: "Coconut Panna Cotta", description: "Silky coconut panna cotta with passion fruit coulis", price: 130,  category: "dessert" },
  { name: "Fresh Coconut Water", description: "Chilled coconut water served in the shell",           price: 90,   category: "drink" }
].each { |attrs| bangkok_bites.menu_items.create!(attrs) }

puts "Done! Seeded #{Restaurant.count} restaurants and #{MenuItem.count} menu items."
puts "Login: admin@hungryhub.com / password123"
