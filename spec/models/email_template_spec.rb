# == Schema Information
#
# Table name: email_templates
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  from_email         :string(255)
#  from_name          :string(255)
#  subject            :string(255)
#  body               :string(255)
#  copy_assigned_user :boolean
#  created_at         :datetime
#  updated_at         :datetime
#

require 'spec_helper'

describe EmailTemplate do
  pending "add some examples to (or delete) #{__FILE__}"
end
