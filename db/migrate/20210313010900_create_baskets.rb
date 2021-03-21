class CreateBaskets < ActiveRecord::Migration[5.2]
  def change
    create_table :baskets do |t|
      t.string :name, null: false
      t.integer :price, null: false
      t.string :process
      t.integer :num, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
