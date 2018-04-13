class CreateCarpools < ActiveRecord::Migration[5.2]
  def change
    create_table :carpools do |t|
      t.references :user, index: true
      t.integer :from_city_id
      t.integer :to_city_id
      t.text :note
      t.datetime :deleted_at
      t.boolean :full, default: false

      t.timestamps
    end

    add_index :carpools, :deleted_at
  end
end
