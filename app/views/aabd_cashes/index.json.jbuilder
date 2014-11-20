json.array!(@aabd_cashes) do |aabd_cash|
  json.extract! aabd_cash, :id
  json.url aabd_cash_url(aabd_cash, format: :json)
end
