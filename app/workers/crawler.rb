class Crawler
  @@base = "2"
  @@interface = "statuses"
  
  def self.conn
    @@conn ||= Faraday.new(:url => 'https://api.weibo.com') do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
  end
  
  def self.get(url, params)
    res = conn.get do |req|
      req.url url
      req.params.merge!(params)
    end
  end
  
  protected 
    def self.build_url(target)
      "/#{@@base}/#{@@interface}/#{target}"
    end
    
    def self.hashie(response)
      json_body = JSON.parse(response.body)
      if json_body.is_a? Array
        Array.new(json_body.count){|i| Hashie::Mash.new(json_body[i])}
      else
        Hashie::Mash.new json_body
      end
    end
    
end

