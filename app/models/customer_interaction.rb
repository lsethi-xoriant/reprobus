class CustomerInteraction < ActiveRecord::Base

  # emailed_at:    timestamp
  # emailed_to:    string
  # document_type: integer
  # document:      copy

  mount_uploader :attachment

  enum document_type: [ :quote, :confirmed_itinerary ]

end