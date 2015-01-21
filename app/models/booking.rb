# == Schema Information
#
# Table name: bookings
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  enquiry_id  :integer
#  user_id     :integer
#  amount      :decimal(12, 2)
#  deposit     :decimal(12, 2)
#  name        :string(255)
#  status      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  xpayments   :text
#  xero_id     :string(255)
#  xdeposits   :text
#

class Booking < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :enquiry
  belongs_to  :customer
  serialize   :xpayments
  has_one     :invoice
  
  def create_invoice_xero(user)
    xero = Xero.new()
    # TODO need some error handling in here.
    success = xero.create_invoice(self)
        
    #act = self.activities.create(type: "Converted", description: "Invoice created in Xero")
    #if act
    #  user.activities<<(act)
    #end  
    
    return success
  end
  
  def get_invoice_xero
    xero = Xero.new()
    inv = xero.get_invoice(self.xero_id)
    return inv
  end
  
  def add_xero_payment(amount)
    xero = Xero.new()
    # TODO need some error handling in here.
    xero.create_payment(self, amount)
        
    #act = self.activities.create(type: "Note", description: "Payment submitted to xero:  $#{amount}")
    #if act
    #  user.activities<<(act)
    #end     
  end
  
  def change_xero_invoice(amount)
    xero = Xero.new()
    # TODO need some error handling in here.
    xero.change_invoice(self, amount)
        
    #act = self.activities.create(type: "Note", description: "Payment submitted to xero:  $#{amount}")
    #if act
    #  user.activities<<(act)
    #end     
  end
  
  
  def initInvoiceDates
    if !self.enquiry.est_date.blank? 
      if (self.enquiry.est_date - 90) > Date.today && self.enquiry.est_date > Date.today 
        return (self.enquiry.est_date - 30), (self.enquiry.est_date - 90)
      elsif (self.enquiry.est_date - 30) > Date.today 
        return (self.enquiry.est_date - 30), (self.enquiry.est_date - 30)
      else
        return (Date.today), (Date.today)  
      end
    else
      return (Date.today + 30), (Date.today + 60)
    end
  end

  def dasboard_customer_name
    if !self.customer.nil? 
      self.customer.dashboard_name
    else 
      "No Customer Details"
    end
  end
  
  def assigned_to_name
    if self.user 
      self.user.name
    end
  end
  
  def created_by_name
    self.user.name
    #User.find(self.user_id).name
  end  
end
