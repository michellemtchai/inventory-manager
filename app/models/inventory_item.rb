require 'net/http'
require 'json'

class InventoryItem < ApplicationRecord
  attribute :weather
  belongs_to :product
  belongs_to :city
  validates :count, :presence => true,
    numericality: { greater_than_or_equal_to: 0 }

  def as_json
    super(:only => [:product, :count], :methods => [:location, :weather])
  end

  def location
    city.label
  end

  def weather
    request_url = "https://api.openweathermap.org/data/3.0/onecall?lat=#{city.lat}&lon=#{city.long}&appid=#{ENV["OPENWEATHER_SECRET"]}&exclude=current,minutely,hourly,alerts"
    response = Rails.cache.fetch(request_url, :expires => 4.hour) do
        Net::HTTP.get_response(URI(request_url))
    end
    body = JSON.parse(response.body)
    p body
    body["daily"][0]["weather"][0]["description"]
  end
end
