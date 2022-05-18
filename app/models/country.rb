class Country < ApplicationRecord
  has_many :cities
  validates :name, :presence => true
  validates :code, :presence => true
end
