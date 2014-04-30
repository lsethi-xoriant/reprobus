module ApplicationHelper
  
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Otter"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  
  #         options = { renderer: {...} , params: {...}
  def paginate(options = {})
    collection = options.delete(:collection)
    options = { renderer: RemoteLinkPaginationHelper::LinkRenderer }.merge(options)
    will_paginate(collection, options)
  end  
end
