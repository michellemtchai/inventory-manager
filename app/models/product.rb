class Product < ApplicationRecord
  has_many :inventory_items
  validates :name, :presence => true
  validates :description, :presence => true
  validates_uniqueness_of :name, :scope => [:description]

  def name_with_id
    "#{name} (ID: #{id})"
  end
end
