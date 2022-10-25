class AddBrandToModels < ActiveRecord::Migration[7.0]
  def change
    add_reference :models, :brand, null: false, foreign_key: true
  end
end
