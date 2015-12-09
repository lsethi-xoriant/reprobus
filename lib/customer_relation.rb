module CustomerRelation
  def is_customer_lead(customer)
    return (self.lead_customer == customer) || (customer.lead_customer == 'true')
  end
  
  def add_customer(customer)
    #self.customer_enquiries.create!(customer_id: customer.id) unless customer.nil?
    self.customers << customer unless customer.nil?
  end
 
  def set_lead
    self.customers.each do |c|
      self.update_column(:lead_customer_id, c.id) if c.lead_customer
    end
    
    if !self.lead_customer
      # if lead customer not set default to first customer
      self.update_column(:lead_customer_id,self.customers.first.id) if self.customers.first
    end
    
    if self.class.name == "Enquiry"
      self.lead_customer ? self.update_column(:lead_customer_name, self.lead_customer.fullname) : self.update_column(:lead_customer_name, "")
    end
  end
  
  def removeInvalidCustomerError
    if self.errors && self.errors.messages[:customers]
      self.errors.messages.delete(:customers)
    end
    
    if self.errors && self.errors.messages[:"customers.lead_customer"]
      self.errors.messages.delete(:"customers.lead_customer")
    end
  end
  
  def created_by_name
    self.user.name
  end
  
  def agent_name
    return self.agent.fullname if self.agent
  end
  
  def assigned_to_name
    self.assignee.name if self.assignee
  end

  def assigned_to_id
    self.assignee.id if self.assignee
  end
  
  def customer_name_and_title
    str = ""
    if self.lead_customer
      str = self.lead_customer.title + " " if self.lead_customer.title
      str = str + self.lead_customer.first_name + " " + self.lead_customer.last_name
    else
      str = "No Customer Details"
    end
  end
  
  def agent_name_and_title
    agent = self.agent
    if agent.present?
      [agent.title, agent.first_name, agent.last_name].join(' ').squish
    else
      'No Agent Details'
    end
  end
  
  def dasboard_customer_name
    self.lead_customer ? self.lead_customer.last_name + ", " + self.lead_customer.first_name : "No Customer Details"
  end
  
  def customer_names
    str = ""
    self.customers.each do |cust|
      str = str + cust.first_name + " " + cust.last_name + ", "
    end
    return str.chomp(", ")
  end
  
  def customer_title
    self.lead_customer.title! unless !self.lead_customer
  end
  
  def customer_address
    if self.agent
      self.agent.getAddressDetails
    else
      self.lead_customer.getAddressDetails if self.lead_customer
    end
  end
  
  def customer_email
    if self.agent
      self.agent.email unless self.agent.email.blank?
    else
      self.lead_customer.email if self.lead_customer
    end
  end
  
  def customer_email_link
    if self.agent
      self.agent.create_email_link unless self.agent.email.blank?
    else
      self.lead_customer.create_email_link if self.lead_customer
    end
  end
  
  def customer_phone
    if self.agent
      self.agent.phone unless self.agent.phone.blank?
    else
      self.lead_customer.phone if self.lead_customer
    end
  end
  
  def customer_mobile
    if self.agent
      self.agent.mobile unless self.agent.mobile.blank?
    else
      self.lead_customer.mobile if self.lead_customer
    end
  end

  def get_first_customer_num
    num = self.lead_customer.id unless self.lead_customer.nil?
  end
    
  def first_customer
    return self.lead_customer unless self.lead_customer.nil?
  end
    
  def validate_new_customer(email, mobile)
    if !email.strip == ""
      cust = Customer.find_by_email(email)
      if !cust.nil?
        errors.add(:CustomerExists,"Customer already exists with this email: #{cust.fullname}")
      end
    end
    if mobile.strip == ""
      cust = Customer.find_by_mobile(mobile)
      if !cust.nil?
        errors.add(:CustomerExists,"Customer already exists with this mobile: #{cust.fullname}")
      end
    end
  end
end
