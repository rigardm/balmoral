class CreateSpendings < ActiveRecord::Migration[6.1]
  def change
    create_table :spendings do |t|
      t.float :amount
      t.string :name
      t.string :category
      t.date :date
      t.text :details
      t.references :tribe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
