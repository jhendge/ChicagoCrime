class CreateCrimes < ActiveRecord::Migration
  def change
    create_table :crimes do |t|
      t.string :date
      t.string :primary_type
      t.string :description
      t.string :location_description
      t.float :latitude
      t.float :longitude
      t.integer :community_area
      t.integer :district
      t.integer :temp
      t.string :block

      t.timestamps
    end
  end
end
