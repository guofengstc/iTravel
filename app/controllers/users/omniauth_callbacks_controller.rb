class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def auth
    
    @user = User.find_with_omniauth(request.env["omniauth.auth"], current_user)
    fields = env["omniauth.auth"] || request.env['rack.auth']    
    
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => fields["provider"].titleize) if is_navigational_format?
    else
      #session["devise.omniauth_data"] = request.env["omniauth.auth"]
      auth = request.env["omniauth.auth"]
      session['devise.omniauth_data'] = {
        name: auth.extra.raw_info.name,
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email
      }
      redirect_to add_email_url 
      #redirect_to new_user_registration_url
    end
  end
  
  alias_method :github, :auth
  alias_method :weibo, :auth
  
end