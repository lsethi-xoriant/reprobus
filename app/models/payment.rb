# == Schema Information
#
# Table name: payments
#
#  id             :integer          not null, primary key
#  amount         :decimal(12, 5)
#  payment_ref    :string(255)
#  invoice_id     :integer
#  created_at     :datetime
#  updated_at     :datetime
#  reference      :text
#  date           :date
#  cc_payment     :boolean          default("false")
#  cc_payment_ref :string
#  cc_client_info :string
#

class Payment < ActiveRecord::Base
  belongs_to  :invoice
  scope :notReconciled, -> {where(payment_ref: nil)}
  scope :ccPayments, -> {where(cc_payment: true)}
  scope :ddPayments, -> {where(cc_payment: false)}
  
  
  def payment_ref_display
    if payment_ref
      return payment_ref
    else
      if Setting.find(1).use_xero
        return "Payment not matched to xero"
      else
        return ""
      end
    end
  end
end
