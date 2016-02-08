module StaticPagesHelper
  
  def count_new_enquiries_this_week
    Enquiry.where('created_at >= ?', 1.week.ago).count
  end
  
  def count_new_enquiries_for_me
    current_user.assigned_enquiries.new_enquiries.count
  end
  
  def count_total_outstanding_enquiries_for_me
    enqs = current_user.assigned_enquiries.active
    tot = 0
    enqs.each do |e|
      if e.amount
        tot = tot + e.amount
      end
    end
    number_to_currency(tot, precision: 0)
  end
  
  def count_total_outstanding_enquiries
    enqs =  Enquiry.active
    tot = 0
    enqs.each do |e|
      tot = tot + e.amount
    end
    number_to_currency(tot, precision: 0)
  end
  
  def count_total_converted_bookings_month
    books = Booking.where('created_at >= ? AND user_id = ?', 1.month.ago, current_user.id)

    tot = 0
    books.each do |b|
      tot = tot + b.getCustomerInvoicesAmount
    end
    number_to_currency(tot, precision: 0)
  end

  def count_total_converted_bookings_year_avg
    books = Booking.where('created_at >= ? AND user_id = ?', 1.year.ago, current_user.id)
    tot = 0
    books.each do |b|
      tot = tot + b.getCustomerInvoicesAmount
    end
     
    tot = tot/12 if tot > 0
    number_to_currency(tot, precision: 0)
  end
  
  def count_total_converted_bookings_year
    books = Booking.where('created_at >= ? AND user_id = ?', 1.year.ago, current_user.id)
    tot = 0
    books.each do |b|
      tot = tot + b.getCustomerInvoicesAmount
    end
    number_to_currency(tot, precision: 0)
  end
  
  def top_five_open_enquiries_for_me
    # have to go in looking at all enquiries, as if used current_user.assigned_enquiries ordering is stuffed up.
    enqs = Enquiry.active.where("assigned_to = ?",current_user.id).order("enquiries.amount DESC").limit(5)
    return enqs
  end
  
  def top_five_neglected_enquiries_for_me
    enqs = Enquiry.active.where("assigned_to = ?",current_user.id).order("enquiries.updated_at ASC").limit(5)
    return enqs
  end

end
