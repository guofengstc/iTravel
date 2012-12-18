class UserCrawler < Crawler
  @queue = :users_queue
  
  def self.perform(token_info)
    puts "token_info => #{token_info}"
  end  

end

