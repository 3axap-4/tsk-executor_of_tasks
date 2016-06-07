json.array!(@clients) do |client|
  json.extract! client, :id, :new, :create, :edit, :update, :destroy, :index, :show
  json.url client_url(client, format: :json)
end
