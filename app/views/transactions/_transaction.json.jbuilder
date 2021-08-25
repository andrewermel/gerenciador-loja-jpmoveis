json.extract! transaction, :id, :quantity, :price_per_unity, :product_id, :user_id, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
