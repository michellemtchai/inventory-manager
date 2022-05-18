class Product < ApplicationRecord
  has_many :inventory_items
  validates :name, :presence => true
  validates :description, :presence => true
end
