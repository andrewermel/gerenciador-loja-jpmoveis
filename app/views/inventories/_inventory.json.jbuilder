json.extract! inventory, :id, :quantity, :product_id, :created_at, :updated_at
json.url inventory_url(inventory, format: :json)
