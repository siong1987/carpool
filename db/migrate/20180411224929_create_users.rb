class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :facebook_user_id
      t.string :phone_number
      t.string :phone_country_prefix
      t.string :phone_national_number
      t.boolean :verified, default: false

      t.timestamps
    end
    add_index :users, :facebook_user_id, unique: true
  end
end
