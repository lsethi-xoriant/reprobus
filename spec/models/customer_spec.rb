# == Schema Information
#
# Table name: customers
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  lead_id         :integer
#  assigned_to     :integer
#  reports_to      :integer
#  first_name      :string(64)       default(""), not null
#  last_name       :string(64)       default(""), not null
#  title           :string(64)
#  source          :string(32)
#  email           :string(64)
#  alt_email       :string(64)
#  phone           :string(32)
#  mobile          :string(32)
#  fax             :string(32)
#  blog            :string(128)
#  linkedin        :string(128)
#  facebook        :string(128)
#  twitter         :string(128)
#  born_on         :date
#  do_not_call     :boolean          default(FALSE), not null
#  deleted_at      :datetime
#  background_info :string(255)
#  skype           :string(128)
#  created_at      :datetime
#  updated_at      :datetime
#  issue_date      :date
#  expiry_date     :date
#  place_of_issue  :string(255)
#  passport_num    :string(255)
#  insurance       :string(255)
#  gender          :string(255)
#  emailID         :string(255)
#  xero_id         :string(255)
#  cust_sup        :string(255)
#  supplier_name   :string(255)
#  currency_id     :integer
#

require 'spec_helper'

describe Customer do
  pending "add some examples to (or delete) #{__FILE__}"
end
