class UpdateBookTotalQty < ActiveRecord::Migration[7.0]
  def change
    BookMaster.update_all(total_qty: 1)
  end
end
