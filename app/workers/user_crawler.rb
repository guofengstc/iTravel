class UserCrawler < Crawler
  @queue = :users_queue
  @@interface = "friendships"  

  def self.perform(token_info, user_id)
    current_user = User.find(user_id)
    puts "#{token_info} & #{current_user}"
    friends = get_friends(token_info)
    puts "=========> get_friends #{friends}"
    save_friends(friends, current_user)
    followers = get_followers(token_info)
    puts "=========> get_friends #{followers}"
    save_followers(followers, current_user)
  end  
  
  private 
    def self.get_friends(token_info)
      get_users("friends.json", 200, token_info)
    end
    
    def self.get_followers(token_info)      
      get_users("followers.json", 200, token_info)
    end
    
    def self.save_friends(users, current_user)
      users.each do |userinfo|
        user = User.save(userinfo, "weibo")
        puts "========> save #{user}"
        if !current_user.friend_with?(user)
          current_user.friendships.build(:friend_id => user.id).save!
        end
      end
    end
    
    def self.save_followers(users, current_user)
      users.each do |userinfo|
        user = User.save(userinfo, "weibo")
        puts "========> save #{user}"
        if !current_user.inverse_friend_with?(user)
          current_user.inverse_friendships.build(:user_id => user.id).save!
        end
      end
    end
    
    def self.get_users(target, count, token_info)
      params = {"count" => count, "access_token" => token_info["token"], "uid" => token_info["uid"]}
      resp = get(build_url(target), params)
      hashie(resp).users
    end
end

