class CreateRides < ActiveRecord::Migration[5.2]
  def change
    create_table :rides do |t|
      t.references :user
      t.integer :from_city_id
      t.integer :to_city_id
      t.text :note

      t.timestamps
    end
  end
end
