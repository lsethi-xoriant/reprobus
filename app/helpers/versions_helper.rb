# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module VersionsHelper

  # Parse the changes for each version
  #----------------------------------------------------------------------------
  def parse_version(attr_name, change)
    if attr_name =~ /\Acf_/ and (field = CustomField.where(:name => attr_name).first).present?
      label = field.label
      first = field.render(change.first)
      second = field.render(change.second)
    else
      #      label = t(attr_name)  # taken out as locals not set up yet.  
      label = ActiveSupport::Inflector.humanize(attr_name)
      first = change.first
      second = change.second
    end

    # Find account and link to it.
    if attr_name == 'account_id'
      if first.present? and (account = Account.find_by_id(first))
        first = link_to(h(account.name), account_path(account))
      end
      if second.present? and (account = Account.find_by_id(second))
        second  = link_to(h(account.name), account_path(account))
      end
    end

    [label, first, second]
  end
end
