require 'csv'

cities = [
  {
    name: 'Tokyo',
    region: nil,
    country: 'Japan',
    lat: 35.695126,
    long: 139.75391
  },
  {
    name: 'Delhi',
    region: nil,
    country: 'India',
    lat: 28.557163,
    long: 77.163665
  },
  {
    name: 'Shanghai',
    region: nil,
    country: 'China',
    lat: 31.246027,
    long: 121.483385
  },
  {
    name: 'São Paulo',
    region: nil,
    country: 'Brazil',
    lat: -23.570533,
    long: -46.663713
  },
  {
    name: 'Mexico City',
    region: 'DF',
    country: 'Mexico',
    lat: 19.371422,
    long: -99.150344
  },
]
products = [
  {
    name: 'Cheerios',
    description: 'Cereal from General Mills.',
  },
  {
    name: "Fruity Loops",
    description: "Cereal from Kellogg's.",
  },
  {
    name: 'Lucky Charms',
    description: 'Cereal from General Mills.',
  },
]
inventory_items = [
  {
    product: 'Cheerios',
    city: 'Mexico City',
    count: 100,
  },
  {
    product: 'Cheerios',
    city: 'Shanghai',
    count: 3200,
  },
  {
    product: 'Fruity Loops',
    city: 'São Paulo',
    count: 30,
  },
  {
    product: 'Lucky Charms',
    city: 'Delhi',
    count: 7632,
  },
]

countries_csv = Rails.root.join('db', 'seeds', 'countries.csv')

if Country.count == 0 && City.count == 0
  country_map = {}
  cities_map = {}
  products_map = {}
  countries = cities.map { |city| city[:country] }
  CSV.foreach(countries_csv, headers: true) do |row|
    country = Country.create!(row.to_hash)
    if countries.include?(country.name)
      country_map[country.name] = country
    end
  end

  cities.each do |city|
    cities_map[city[:name]] = City.create!({
      **city,
      country: country_map[city[:country]]
    })
  end

  products.each do |product|
    products_map[product[:name]] = Product.create!(product)
  end

  inventory_items.each do |item|
    InventoryItem.create!({
      **item,
      product: products_map[item[:product]],
      city: cities_map[item[:city]]
    })
  end

  puts "Seeding completed!"
else
  puts "Seeding already done!"
end
