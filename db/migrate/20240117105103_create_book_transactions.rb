class CreateBookTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :book_transactions do |t|
      t.references :book_master, null: false, foreign_key: true
      t.datetime :borrow_date
      t.datetime :return_date
      t.references :borrower, null: false, foreign_key: true

      t.timestamps
    end
  end
end
