Headcount.configure do |config|
  # config.path = 'db/headcounts.json' # where to write headcount to
  config.timestamp = '%'
  
  now = DateTime.now
  
  count User do
    a = now - 7.days
    b = now - 30.days
    c = now - 90.days
    
    count User.where("last_request_at >= ?",                        a),     :as => :active
    count User.where("last_request_at < ? AND last_request_at > ?", a, b),  :as => :semi_active
    count User.where("last_request_at <= ?",                        c),     :as => :inactive
  end
end