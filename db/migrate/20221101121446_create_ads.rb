class CreateAds < ActiveRecord::Migration[7.0]
  def change
    create_table :ads do |t|
      t.string :description
      t.integer :price
      t.integer :stage
      t.string :reason_for_rejection

      t.timestamps
    end
    add_reference :ads, :car, null: false, foreign_key: true
    add_reference :ads, :user, null: false, foreign_key: true
  end
end
