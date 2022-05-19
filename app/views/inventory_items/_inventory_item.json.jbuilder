json.(inventory_item, :id, :count, :location, :weather)
json.product do
  json.(inventory_item.product, :id, :name, :description)
end
