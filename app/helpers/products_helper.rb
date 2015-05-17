module ProductsHelper
  def get_edit_path(product)
    if product.type == 'Transfer'
      return edit_products_transfer_path(product)
    elsif product.type == 'Tour'
      return edit_products_tour_path(product)
    elsif product.type == 'Flight'
      return edit_products_flight_path(product)
    elsif product.type == 'Cruise'
      return edit_products_cruise_path(product)
    elsif product.type == 'Hotel'
      return edit_products_hotel_path(product)
    end
  end
  
  def product_index_path(product)
    if product.type == 'Transfer'
      return products_transfers_path
    elsif product.type == 'Tour'
      return products_tours_path
    elsif product.type == 'Flight'
      return products_flights_path
    elsif product.type == 'Cruise'
      return products_cruises_path
    elsif product.type == 'Hotel'
      return products_hotels_path
    end
  end

  def get_new_path(type)
    if type == 'Transfer'
      return new_products_transfer_path()
    elsif type == 'Tour'
      return new_products_tour_path()
    elsif type == 'Flight'
      return new_products_flight_path()
    elsif type == 'Cruise'
      return new_products_cruise_path()
    elsif type == 'Hotel'
      return new_products_hotel_path()
    end
  end
  
  def nice_products_name(type)
    return type.pluralize
  end
end
