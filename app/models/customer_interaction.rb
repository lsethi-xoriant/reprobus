# == Schema Information
#
# Table name: customer_interactions
#
#  id            :integer          not null, primary key
#  emailed_at    :datetime
#  emailed_to    :string
#  document_type :integer
#  attachment    :string
#  itinerary_id  :integer
#

class CustomerInteraction < ActiveRecord::Base

  # emailed_at:    timestamp
  # emailed_to:    string
  # document_type: integer
  # document:      copy

  mount_uploader :attachment, AttachmentUploader

  belongs_to :itinerary

  enum document_type: [ :quote, :confirmed_itinerary ]

end
