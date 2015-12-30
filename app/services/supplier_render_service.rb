class SupplierRenderService
  def self.as_pdf(itinerary, itinerary_price, itinerary_price_item, itinerary_infos, supplier)
    locals = { 
                :@itinerary_price_item => itinerary_price_item,
                :@itinerary_price      => itinerary_price,
                :@supplier             => supplier,
                :@itinerary            => itinerary,
                :@itinerary_infos      => itinerary_infos
              }

    body_html = 
      render_template_with_locals('itinerary_prices/printQuote.pdf.erb', locals)
    
    WickedPdf.new.pdf_from_string(
      body_html,
      pdf: "Supplier_no_" + itinerary.id.to_s.rjust(8, '0'),
      margin: { bottom: 15 }
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
