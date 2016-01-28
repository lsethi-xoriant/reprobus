# == Schema Information
#
# Table name: settings
#
#  id                         :integer          not null, primary key
#  company_name               :string(255)
#  pxpay_user_id              :string(255)
#  pxpay_key                  :string(255)
#  use_xero                   :boolean
#  xero_consumer_key          :string(255)
#  xero_consumer_secret       :string(255)
#  created_at                 :datetime
#  updated_at                 :datetime
#  currency_id                :integer
#  payment_gateway            :string(255)
#  cc_mastercard              :decimal(5, 4)
#  cc_visa                    :decimal(5, 4)
#  cc_amex                    :decimal(5, 4)
#  dropbox_user               :string
#  dropbox_session            :text
#  use_dropbox                :boolean
#  dropbox_default_path       :string
#  itinerary_includes         :text
#  itinerary_excludes         :text
#  itinerary_notes            :text
#  itinerary_default_image_id :integer
#  company_logo_id            :integer
#  send_emails_turned_off     :boolean
#  quote_introduction         :text
#  confirmed_introduction     :text
#  num_days_balance_due       :integer          default("95")
#  num_days_deposit_due       :integer          default("7")
#  deposit_percentage         :integer          default("0")
#  itineraries_from_email     :string
#  important_notes            :text
#  overide_email_addresses    :text
#  overide_emails             :boolean
#  pin_payment_public_key     :string
#  pin_payment_secret_key     :string
#  invoice_banking_details    :text
#  invoice_company_address    :text
#  invoice_company_contact    :text
#  invoice_footer             :text
#  pin_payment_url            :string
#  base_url                   :string
#  about_company              :text
#

class Setting < ActiveRecord::Base
  validates_presence_of :xero_consumer_key,:xero_consumer_secret, :if => lambda { self.use_xero }
  validates_presence_of :pxpay_user_id, :pxpay_key, :if => lambda { self.payment_gateway == "Payment Express" }

  validates :cc_mastercard,:cc_visa,:cc_amex,  :numericality => {:greater_than => 0, :less_than => 1}, :allow_blank => true
  
  belongs_to  :itinerary_default_image, :class_name => "ImageHolder", :foreign_key => :itinerary_default_image_id
  belongs_to  :company_logo, :class_name => "ImageHolder", :foreign_key => :company_logo_id
  accepts_nested_attributes_for :itinerary_default_image, allow_destroy: true
  accepts_nested_attributes_for :company_logo, allow_destroy: true
  
  belongs_to :currency
  has_many :exchange_rates
  has_many :suppliers, :class_name => "Customer"
  accepts_nested_attributes_for :suppliers
  
  has_many :triggers, -> { order ('id ASC') }
  accepts_nested_attributes_for :triggers
 
  before_save :reset_dropbox

  def reset_dropbox
    if !self.use_dropbox
      self.dropbox_default_path = ""
      self.dropbox_session =  ""
      self.dropbox_user = ""
    end
  end
  
  def dropbox_default_path=(value)
    if !value.blank?
      value = value + "/" if value[-1] != "/"
      value = "/" + value if value[0] != "/"
    end
    
    self[:dropbox_default_path] = value
  end
  
  def self.global_settings
    return Setting.find(1); # current only one of these, will have to work out a way to make this multi tenancy. 
  end
  
  def get_company_logo_image_link
    if self.company_logo  then 
      return self.company_logo.get_image_link()
    else
      return ActionController::Base.helpers.image_path('noImage.jpg')
    end
  end  
 
  def get_itinerary_default_image_link
    if self.itinerary_default_image  then 
      return self.itinerary_default_image.get_image_link()
    else
      return ActionController::Base.helpers.image_path('noImage.jpg')
    end
  end 
  
  def getDefaultCurrency
    self.currency ? self.currency : Currency.find_by_code("USD")
  end
  def currencyID
    return self.getDefaultCurrency.id
  end
  def currencyCode
    return self.getDefaultCurrency.code
  end
  def currencyDisplay
    return self.getDefaultCurrency.displayName
  end
  
  def usesPaymentGateway
    return !self.payment_gateway.blank? && self.payment_gateway != "None"
  end
  
  def usesPinPayments?
    return self.payment_gateway == "Pin Payments"
  end
  
  def get_cc_mastercard_display
    return self.cc_mastercard * 100 if self.cc_mastercard
  end
  def get_cc_visa_display
    return self.cc_visa * 100 if self.cc_visa
  end
  def get_cc_other_display
    return self.cc_amex * 100 if self.cc_amex
  end
  
  def cc_mastercard=(value)
    if value && is_number?(value)
      value = value.to_f/100
    end
    write_attribute(:cc_mastercard, value)
  end
  def cc_visa=(value)
    if value && is_number?(value)
      value = value.to_f/100
    end
    write_attribute(:cc_visa, value)
  end
  def cc_amex=(value)
    if value && is_number?(value)
      value = value.to_f/100
    end
    write_attribute(:cc_amex, value)
  end
  
  def is_number?(mystring)
    true if Float(mystring) rescue false
  end
  
end
