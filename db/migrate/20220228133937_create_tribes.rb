class CreateTribes < ActiveRecord::Migration[6.1]
  def change
    create_table :tribes do |t|
      t.integer :credits
      t.string :color
      t.float :shareholding
      t.references :house, null: false, foreign_key: true

      t.timestamps
    end
  end
end
