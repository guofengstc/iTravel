class CreateFootprintImages < ActiveRecord::Migration
  def change
    create_table :footprint_images do |t|
      t.references :footprint
      t.string :src

      t.timestamps
    end
    add_index :footprint_images, :footprint_id
  end
end
