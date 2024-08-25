require 'net/http'
require 'json'

class InventoryItem < ApplicationRecord
  attribute :weather
  belongs_to :product
  belongs_to :city
  validates :count, :presence => true,
    numericality: { greater_than_or_equal_to: 0 }
  validates_uniqueness_of :product_id, :scope => [:city_id]

  def location
    city.label
  end

  def weather
    begin
      request_url = "https://api.openweathermap.org/data/3.0/onecall?lat=#{city.lat}&lon=#{city.long}&appid=#{ENV["OPENWEATHER_SECRET"]}"
      response = Rails.cache.fetch(request_url, :expires => 4.hour) do
          Net::HTTP.get_response(URI(request_url))
      end
      if response.code == "200"
        body = JSON.parse(response.body)
        body["current"]["weather"][0]["description"]
      else
        "Error: #{response.message}"
      end
    rescue =>e
      "Error: #{e.message}"
    end
  end
end
