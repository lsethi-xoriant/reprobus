# == Schema Information
#
# Table name: products
#
#  id                   :integer          not null, primary key
#  type                 :string
#  name                 :string
#  description          :text
#  price_single         :decimal(12, 2)
#  price_double         :decimal(12, 2)
#  price_triple         :decimal(12, 2)
#  room_type            :string
#  rating               :string
#  destination          :string
#  default_length       :integer
#  created_at           :datetime
#  updated_at           :datetime
#  image                :string
#  country_id           :integer
#  destination_id       :integer
#  country_search       :string
#  destination_search   :string
#  remote_url           :string
#  hotel_id             :integer
#  address              :text
#  phone                :string
#  cruise_id            :integer
#  group_classification :string
#  includes_breakfast   :boolean
#  includes_lunch       :boolean
#  includes_dinner      :boolean
#

class Room < Product
  
  before_save  :set_from_parent
  
  def set_from_parent
    self.country_id = self.hotel.country_id if self.hotel
    self.destination_id = self.hotel.destination_id if self.hotel
    self.suppliers   = self.hotel.suppliers if self.hotel
  end
  
  def self.sti_name
    "Room"
  end
  
  def room_type=(value)
    self.name = value
    super(value)
  end
  
  def self.handle_file_import(spreadsheet, fhelp, job_progress, type, run_live)
      header = spreadsheet.row(1)
      header = header.map(&:upcase)
      
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        
        count = Country.find_by_name(row["COUNTRY"])
        dest = Destination.find_by_name(row["DESTINATION"])
   
        
        #hotel must exist to add room to a hotel
        hotel = Hotel.find_by name: row["HOTEL"], destination: dest, country: count
        
        if hotel.nil?
          fhelp.add_skip_record("Row " + (i-1).to_s + " skipped as no matching Hotel to assign rooms to : #{row["HOTEL"]} | #{row["COUNTRY"]} | #{row["DESTINATION"]}");
          next 
        end
          
        hr = Room.find_by room_type: row["ROOMTYPE"], hotel: hotel
        
        if hr
          fhelp.add_skip_record("Row " + (i-1).to_s + " skipped as room with this name already exists on hotel : #{row["ROOMTYPE"]} | #{row["HOTEL"]} | #{row["COUNTRY"]} | #{row["DESTINATION"]}");
          next
        end

        ent = new
        
        ent.type = type
        ent.hotel = hotel
        ent.room_type = row["ROOMTYPE"]
        str = (row["DESCRIPTION"])
        ent.description = str
        str = (row["IMAGENAME"])
        ent.remote_url = str
  
        if (run_live && !ent.save) || (!run_live && !ent.valid?)
          fhelp.add_validation_record("#{type}: #{ent.name} has validation errors - #{ent.errors.full_messages}")
          next
        end
        
        fhelp.int = fhelp.int + 1
        job_progress.update_progress(fhelp)
      end
      
    return fhelp;
  end  
end
