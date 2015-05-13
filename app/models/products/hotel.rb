# == Schema Information
#
# Table name: products
#
#  id             :integer          not null, primary key
#  type           :string
#  name           :string
#  country        :string
#  city           :string
#  description    :string
#  price_single   :decimal(12, 2)
#  price_double   :decimal(12, 2)
#  price_tripple  :decimal(12, 2)
#  product_type   :string
#  room_type      :string
#  rating         :string
#  destination    :string
#  default_length :integer
#  supplier_id    :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Hotel < Product
end
