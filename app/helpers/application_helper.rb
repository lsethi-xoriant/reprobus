module ApplicationHelper
  
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "TripEase"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  
  # Returns a dash if the passed in value is nil 
  # (for use in some bootstrap Divs that need a value to size correctly)
  def value_or_dash(value)
    if value.nil?
      return " - "
    else
      return value
    end
  end
  
  #         options = { renderer: {...} , params: {...}
  def paginate(options = {})
    collection = options.delete(:collection)
    options = { renderer: RemoteLinkPaginationHelper::LinkRenderer }.merge(options)
    will_paginate(collection, options)
  end  
   
  def titles_list
    list = ["Ms", 
            "Miss", 
            "Mrs",   
            "Mr",
            "Master",
            "Rev",
            "Father",
            "Dr",
            "Atty",
            "Prof",
            "Hon"]
  end
  
  # adds nice date like: 14 Dec 2014
  def formated_date(date) 
    if !date.nil? then 
      return date.to_formatted_s(:rfc822)
    end
  end
  
     
  module BootstrapExtension
    FORM_CONTROL_CLASS = "form-control"
    LABEL_CONTROL_CLASS = "col-sm-3 control-label"

    # Override the 'text_field_tag' method defined in FormTagHelper[1]
    #
    # [1] https://github.com/rails/rails/blob/master/actionview/lib/action_view/helpers/form_tag_helper.rb
    def text_field(name, value = nil, options = {})
      class_name = options[:class]
      if class_name.nil?
        # Add 'form-control' as the only class if no class was provided
        options[:class] = FORM_CONTROL_CLASS
      else
        # Add ' form-control' to the class if it doesn't already exist
        options[:class] << " #{FORM_CONTROL_CLASS}" if
          " #{class_name} ".index(" #{FORM_CONTROL_CLASS} ").nil?
      end

      # Call the original 'text_field_tag' method to do the real work
      super
    end
    
    def text_field_tag(name, value = nil, options = {})
      class_name = options[:class]
      if class_name.nil?
        # Add 'form-control' as the only class if no class was provided
        options[:class] = FORM_CONTROL_CLASS
      else
        # Add ' form-control' to the class if it doesn't already exist
        options[:class] << " #{FORM_CONTROL_CLASS}" if
          " #{class_name} ".index(" #{FORM_CONTROL_CLASS} ").nil?
      end

      # Call the original 'text_field_tag' method to do the real work
      super
    end
    
    def label(object_name, method, content_or_options = nil, options = nil, &block)
      class_name = options[:class]
      if class_name.nil?
        # Add 'form-control' as the only class if no class was provided
        options[:class] = LABEL_CONTROL_CLASS
      else
        # Add ' form-control' to the class if it doesn't already exist
        options[:class] << " #{LABEL_CONTROL_CLASS}" if
          " #{class_name} ".index(" #{LABEL_CONTROL_CLASS} ").nil?
      end
      # Call the original 'text_field_tag' method to do the real work
      super
    end
    
    def password_field(object_name, method, options = {})
      class_name = options[:class]
      if class_name.nil?
        # Add 'form-control' as the only class if no class was provided
        options[:class] = FORM_CONTROL_CLASS
      else
        # Add ' form-control' to the class if it doesn't already exist
        options[:class] << " #{FORM_CONTROL_CLASS}" if
          " #{class_name} ".index(" #{FORM_CONTROL_CLASS} ").nil?
      end
      # Call the original 'text_field_tag' method to do the real work
      super
    end    
  end

  # Add the modified method to ApplicationHelper
  include BootstrapExtension  
end
