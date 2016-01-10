class AddPinToSettingsPlusOtherInvoiceStuff < ActiveRecord::Migration
  def change
    add_column :settings, :pin_payment_public_key, :string
    add_column :settings, :pin_payment_secret_key, :string

    add_column :settings, :invoice_banking_details, :text
    add_column :settings, :invoice_company_address, :text
    add_column :settings, :invoice_company_contact, :text
    add_column :settings, :invoice_footer, :text
    
  end
end
