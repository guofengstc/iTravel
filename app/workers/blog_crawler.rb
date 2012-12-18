class BlogCrawler < Crawler
  @queue = :blogs_queue
  
  def self.perform(id)
    puts "========> #{id}"
  end

end