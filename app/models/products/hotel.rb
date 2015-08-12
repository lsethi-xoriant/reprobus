# == Schema Information
#
# Table name: products
#
#  id                   :integer          not null, primary key
#  type                 :string
#  name                 :string
#  description          :text
#  price_single         :decimal(12, 2)
#  price_double         :decimal(12, 2)
#  price_triple         :decimal(12, 2)
#  room_type            :string
#  rating               :string
#  destination          :string
#  default_length       :integer
#  created_at           :datetime
#  updated_at           :datetime
#  image                :string
#  country_id           :integer
#  destination_id       :integer
#  country_search       :string
#  destination_search   :string
#  remote_url           :string
#  hotel_id             :integer
#  address              :text
#  phone                :string
#  cruise_id            :integer
#  group_classification :string
#  includes_breakfast   :boolean
#  includes_lunch       :boolean
#  includes_dinner      :boolean
#

class Hotel < Product
  def self.sti_name
    "Hotel"
  end
end
