require 'hashie'
require 'json'
require 'faraday'
class HomeController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @strangers = Kaminari.paginate_array(current_user.strangers).page params[:page] 
    async_create_users(current_user)
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
  
  def async_create_users(user)
    Resque.enqueue(UserCrawler, session["token_info"], user.id)
  end

end
