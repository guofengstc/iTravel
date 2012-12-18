require 'hashie'
require 'json'
require 'faraday'
class HomeController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @strangers = Kaminari.paginate_array(current_user.strangers).page params[:page] 
    friends = (hashie weibo_friendships('followers.json',200,session['token_info'].uid,session['token_info'].token)).users
    friends.each do |userinfo|
      user = User.save(userinfo,"weibo")
      if !current_user.friend_with?(user)
        current_user.friendships.build(:friend_id => user.id).save
      end
    end
  end
  
  def email    
    userinfo = session["devise.omniauth_data"]
    @user = User.new(userinfo)
  end
  
  def create
    userinfo = session["devise.omniauth_data"]
    userinfo = userinfo.delete_if{ |k, v| v == nil || v.empty? }
      .merge!(params[:user].delete_if{ |k, v| v == nil || v.empty? }
      .merge!(:password => Devise.friendly_token[0, 20]))
    @user = User.create(userinfo)
    @user.save!
    redirect_to root_url 
  end

  protected

  def conn
    conn = Faraday.new(:url => 'https://api.weibo.com') do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
  end

  def weibo_friendships(url,count,uid,access_token)
    friendships = _request(url,count,uid,access_token,"friendships")
  end

  def _request(url,count,uid,access_token,interface)
    res = conn.get do |req|
        req.url "/2/#{interface}/#{url}"
        req.params['uid'] = uid
        req.params['count'] = count
        req.params['access_token'] = access_token
    end
  end

  def hashie(response)
    json_body = JSON.parse(response.body)
      if json_body.is_a? Array
        Array.new(json_body.count){|i| Hashie::Mash.new(json_body[i])}
      else
        Hashie::Mash.new json_body
      end
  end

end
