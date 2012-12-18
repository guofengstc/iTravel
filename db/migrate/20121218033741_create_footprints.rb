class CreateFootprints < ActiveRecord::Migration
  def change
    create_table :footprints do |t|
      t.references :user
      t.text :desc
      t.string :longitude
      t.string :latitude
      t.string :address

      t.timestamps
    end
    add_index :footprints, :user_id
  end
end
