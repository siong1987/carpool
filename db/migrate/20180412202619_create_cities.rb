class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities do |t|
      t.string :place_id
      t.string :name
      t.string :state
      t.float :latitude
      t.float :longitude

      t.timestamps
    end

    add_index :cities, :place_id, unique: true
    add_index :cities, [:name, :state], unique: true
  end
end
