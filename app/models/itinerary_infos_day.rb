class ItineraryInfosDay
  attr_accessor :all_infos, :standard_infos, :leaving_hotel, :hotel, :transfer, :cruise, 
                :leg_count, :destination, :country
  
  def set_up_day(itinerary, date, leg_count)
    @standard_infos = []
    @leg_count = leg_count
    @all_infos = itinerary.get_infos_for_date(date) 
  
    @all_infos.order('start_date').each do |info|    
      if info.product.type == "Hotel" 
        if info.end_date == date
          # we are moving out of this hotel on this date. 
          @leaving_hotel = info
          next
        else
          @hotel = info
        end     
      elsif info.product.type == "Transfer"
        @transfer = info
      elsif info.product.type == "Cruise"
        @cruise = info        
      else
         @standard_infos << info
         # set country and destination - this should be main dest/count - not if motel departure. 
         @destination = info.get_product_destination if !@destination 
         @country = info.get_product_country if !@country 
      end
    end
    
    if !@all_infos.empty?
      #set these if they havent already been set. 
      @destination = @all_infos.last.get_product_destination if !@destination 
      @country = @all_infos.last.get_product_country if !@country 
    end
    
  end
  
end