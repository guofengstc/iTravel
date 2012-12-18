Kaminari.configure do |config|
  config.default_per_page = 16
  config.window = 5
  config.outer_window = 0
  config.left = 0
  config.right = 0
  config.param_name = :page  
  # config.max_per_page = nil
  # config.page_method_name = :page
end
