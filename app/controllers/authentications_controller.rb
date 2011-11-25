class AuthenticationsController < ApplicationController
  
  protect_from_forgery :except => :create
  
  def create
    omniauth = request.env["omniauth.auth"] 
    puts "******************"
    puts omniauth
    puts "******************"
    authentication = Authentication.where(:provider => omniauth.provider, :uid => omniauth.uid).first
    if authentication 
      flash[:notice] = t(:signed_in)
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create!(:provider => omniauth.provider, :uid => omniauth.uid)
      flash[:notice] = t(:success)
      redirect_to root_url
    elsif user = create_new_omniauth_user(omniauth)
      user.authentications.create!(:provider => omniauth.provider, :uid => omniauth.uid)
      flash[:notice] = t(:welcome)
      sign_in_and_redirect(:user, user)
    else
      flash[:alert] = t(:fail)
      redirect_to new_user_registration_url   
    end
  end
  
  private
  
  def create_new_omniauth_user(omniauth)
    user = User.where(:email => omniauth.info['email']).first
    unless user
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        user
      else
        nil
      end
    else
      user
    end
  end

end
