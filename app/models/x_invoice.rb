# == Schema Information
#
# Table name: x_invoices
#
#  id             :integer          not null, primary key
#  amount_due     :decimal(12, 5)   default("0.0")
#  amount_paid    :decimal(12, 5)   default("0.0")
#  total          :decimal(12, 5)   default("0.0")
#  currency_code  :string(255)
#  currency_rate  :string(255)
#  date           :date
#  invoice_ref    :string(255)
#  invoice_id     :integer
#  created_at     :datetime
#  updated_at     :datetime
#  last_sync      :datetime
#  invoice_number :string(255)
#  due_date       :date
#  status         :string(255)
#

class XInvoice < ActiveRecord::Base
  belongs_to :invoice
end
