class ItineraryRenderService
  def self.as_pdf(itinerary, setting)
    locals = { 
                :@itinerary => itinerary, 
                :@enquiry   => itinerary.enquiry,
                :@setting   => setting 
              }

    body_html   = 
      render_template_with_locals('itineraries/printQuote.pdf.erb', locals)

    footer_html = 
      render_template_with_locals('itineraries/print_itinerary/footer.pdf.erb', locals)
    
    WickedPdf.new.pdf_from_string(
      body_html,
      pdf: "Itinerary_no_" + itinerary.id.to_s.rjust(8, '0'),
      margin: { bottom: 15 },
      footer: { content: footer_html } 
    )
  end

  private
    def self.render_template_with_locals(template_path, locals)
      @ac ||= ActionController::Base.new() 
      @ac.render_to_string(
        template: template_path,
        locals: locals, 
        layout: false
      )
    end
end