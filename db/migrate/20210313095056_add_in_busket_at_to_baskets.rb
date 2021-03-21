class AddInBusketAtToBaskets < ActiveRecord::Migration[5.2]
  def change
    add_column :baskets, :in_basket_at, :datetime, null: false
  end
end
