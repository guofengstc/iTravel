class BlogCrawler < Crawler
  @queue = :blogs_queue
  
  def self.perform(id)
  end

end