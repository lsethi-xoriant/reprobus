class AddCampaignToEnquiry < ActiveRecord::Migration
  def change
    add_column :enquiries, :campaign , :text
  end
end
