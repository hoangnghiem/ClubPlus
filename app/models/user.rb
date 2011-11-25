class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  field :name
  validates_presence_of :name
  validates_uniqueness_of :email, :case_sensitive => false
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  has_many :authentications, :dependent => :destroy
  
  def apply_omniauth(omniauth)
    self.email = omniauth.info['email'] if email.blank?
    apply_trusted_services(omniauth) if self.new_record?
  end
  
  def apply_trusted_services(omniauth) 
    user_info = omniauth.info
    if self.name.blank?
      self.name   = user_info['name']   unless user_info['name'].blank?
      self.name ||= user_info['nickname'] unless user_info['nickname'].blank?
      self.name ||= (user_info['first_name'] + " " +user_info['last_name']) unless \
        user_info['first_name'].blank? || user_info['last_name'].blank?
    end  
    if self.email.blank?
      self.email = user_info['email'] unless user_info['email'].blank?
    end 
    self.password, self.password_confirmation = SecureRandom.hex(10)
    self.confirmed_at, self.confirmation_sent_at = Time.now 
  end
end

