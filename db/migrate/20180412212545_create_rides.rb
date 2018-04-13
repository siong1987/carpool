class CreateRides < ActiveRecord::Migration[5.2]
  def change
    create_table :rides do |t|
      t.references :user, index: true
      t.integer :from_city_id
      t.integer :to_city_id
      t.text :note
      t.datetime :deleted_at
      t.boolean :success, default: false

      t.timestamps
    end

    add_index :rides, :deleted_at
  end
end
