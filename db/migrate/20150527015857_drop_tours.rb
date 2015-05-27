class DropTours < ActiveRecord::Migration
  def change
    drop_table :tours
  end
end
