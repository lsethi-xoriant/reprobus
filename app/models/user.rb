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
#  admin                  :boolean          default("false")
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
  has_many    :bookings
  has_many    :enquiries

  has_many    :assigned_enquiries, -> { order("enquiries.reminder ASC") }, :class_name => 'Enquiry', :foreign_key => 'assigned_to'
  
  has_many    :activities, dependent: :destroy
  has_many    :itineraries

  has_many    :user_roles 
  has_many    :roles, through: :user_roles
  
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
    UserMailer.password_reset(self).deliver_now
  end
  
  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
  end
  
  def getRemindersDueCount
    int = 0
    self.assigned_enquiries.active.each  do |enq|
      if !enq.reminder.nil? && (enq.reminder.past? || enq.reminder.today?)
        int = int + 1
      end
    end
    return int
  end
  
  
  def getEnquiriesOpenCount
    return self.assigned_enquiries.active.count
  end
  
  def isSystemUser
    return self.name == "System" || self.email == "hamish@writecode.com.au"
  end
 
  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
private
    def create_remember_token
      self.remember_token = User.hash(User.new_remember_token)
    end
  
    def generate_token_pw_reset
       self.password_reset_token = User.new_remember_token
    end
end
