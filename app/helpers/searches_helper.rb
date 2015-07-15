module SearchesHelper

  def select_destinations
    return Destination.order(name: :asc)
  end

  def select_countries
    return Country.order(name: :asc)
  end
end