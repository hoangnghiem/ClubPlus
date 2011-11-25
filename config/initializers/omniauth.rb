require 'omniauth-openid'
require 'openid/store/filesystem'
Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
  provider :facebook, '290493947657436', 'efddb476d21825ef646572944b85fc5b'
  provider :open_id, :store => OpenID::Store::Filesystem.new('./tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id' 
  provider :open_id, :store => OpenID::Store::Filesystem.new('./tmp'), :name => "yahoo", :identifier => "https://me.yahoo.com"
end