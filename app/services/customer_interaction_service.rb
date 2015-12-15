class CustomerInteractionService

  def self.record_interaction(attachments, params)
    return unless attachments.present? && params.present?
    attachments.each do |attachment| 
      file = StringIO.new(attachment.decoded)
      file.class.class_eval { attr_accessor :original_filename, :content_type }
      file.original_filename = attachment.filename
      file.content_type = attachment.mime_type

      type = :quote # change this when Confirmed Itinerary Email will be implemented

      options = 
      {
        emailed_at: DateTime.now,
        emailed_to: params[:to_email],
        document_type: type,
        attachment: file,
        itinerary_id: params[:id]
      }
      customer_interaction = CustomerInteraction.new(options)
      customer_interaction.save
    end
  end
end
