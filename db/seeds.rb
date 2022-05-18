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
countries_csv = Rails.root.join('db', 'seeds', 'countries.csv')

if Country.count == 0 && City.count == 0
  country_map = {}
  countries = cities.map { |city| city[:country] }
  CSV.foreach(countries_csv, headers: true) do |row|
    country = Country.create!(row.to_hash)
    if countries.include?(country.name)
      country_map[country.name] = country
    end
  end
  City.create!(cities.map{ |city| { **city, country: country_map[city[:country]] } })
  puts "Seeding completed!"
else
  puts "Seeding already done!"
end
