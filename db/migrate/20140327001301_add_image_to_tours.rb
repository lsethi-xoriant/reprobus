class AddImageToTours < ActiveRecord::Migration
  def change
    add_column :tours, :image, :string
  end
end
