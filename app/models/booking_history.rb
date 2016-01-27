# == Schema Information
#
# Table name: booking_histories
#
#  id            :integer          not null, primary key
#  emailed_at    :datetime
#  emailed_to    :string
#  document_type :integer
#  attachment    :string
#  itinerary_id  :integer
#

class BookingHistory < ActiveRecord::Base

  # emailed_at:    timestamp
  # emailed_to:    string
  # document_type: integer
  # document:      copy

  mount_uploader :attachment, AttachmentUploader

  belongs_to :itinerary

  enum document_type: [ :quote, :confirmed_itinerary, :supplier_quote, :confirmed_supplier ]

end
