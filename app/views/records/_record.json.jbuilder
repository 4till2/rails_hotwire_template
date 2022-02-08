json.extract! record, :id, :account_id, :recordable_id, :creator_id, :title, :subtitle, :description, :created_at, :updated_at
json.url record_url(record, format: :json)
