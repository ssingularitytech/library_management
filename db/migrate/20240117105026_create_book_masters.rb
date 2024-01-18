class CreateBookMasters < ActiveRecord::Migration[7.0]
  def change
    create_table :book_masters do |t|
      t.string :name
      t.string :author
      t.string :publisher
      t.decimal :price
      t.string :language
      t.string :serial_number
      t.references :topic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
