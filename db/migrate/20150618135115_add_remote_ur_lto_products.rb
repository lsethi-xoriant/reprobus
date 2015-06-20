class AddRemoteUrLtoProducts < ActiveRecord::Migration
  def change
    add_column :products, :remote_url, :string
  end
end
