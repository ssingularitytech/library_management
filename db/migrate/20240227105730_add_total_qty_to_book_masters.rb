class AddTotalQtyToBookMasters < ActiveRecord::Migration[7.0]
  def change
    add_column :book_masters, :total_qty, :integer, default: 0
  end
end
