# == Schema Information
#
# Table name: roles
#
#  id   :integer          not null, primary key
#  name :string
#

class Role  < ActiveRecord::Base
  has_many :user_roles
  has_many :users, through: :user_roles

  validates :name, presence: true
end
