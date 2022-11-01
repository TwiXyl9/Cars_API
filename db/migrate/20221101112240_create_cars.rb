class CreateCars < ActiveRecord::Migration[7.0]
  def change
    create_table :cars do |t|
      t.integer :creation_year
      t.float :engine_capacity
      t.timestamps
    end
    add_reference :cars, :model, null: false, foreign_key: true
  end
end
