class CreateTours < ActiveRecord::Migration
  def change
    create_table :tours do |t|
      t.string :tourName
      t.string :destination
      t.string :country
      t.decimal :tourPrice

      t.timestamps
    end
  end
end
