json.extract! product, :id, :name, :recommended_price, :product_type_id, :created_at, :updated_at
json.url product_url(product, format: :json)
