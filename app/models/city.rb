class City < ApplicationRecord
  belongs_to :country
  validates :name, :presence => true
  validates :lat, :presence => true
  validates :long, :presence => true

  def label
    if region.nil?
      "#{name}, #{country.name}"
    else
      "#{name}, #{region}, #{country.name}"
    end
  end
end
