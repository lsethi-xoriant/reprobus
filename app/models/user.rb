# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  password_digest        :string(255)
#  remember_token         :string(255)
#  remember_me            :boolean
#  admin                  :boolean          default(FALSE)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#

class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
#  validates :password, length: { minimum: 6 }
  
  validates :password, presence: true, length: {minimum: 6, maximum: 120}, on: :create
  validates :password, length: {minimum: 5, maximum: 120}, on: :update, allow_blank: true
  
  before_create :create_remember_token
  
  has_many    :customers
  has_many    :enquiries
  has_many    :assigned_enquiries, :class_name => 'Enquiry', :foreign_key => 'assigned_to'
  
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.hash(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  def send_password_reset
    generate_token_pw_reset
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end
    
private
    def create_remember_token
      self.remember_token = User.hash(User.new_remember_token)
    end
  
    def generate_token_pw_reset
       self.password_reset_token = User.new_remember_token
    end    
end
