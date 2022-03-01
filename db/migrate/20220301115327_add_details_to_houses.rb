class AddDetailsToHouses < ActiveRecord::Migration[6.1]
  def change
    add_column :houses, :address, :string
    add_column :houses, :city, :string
    add_column :houses, :country, :string
  end
end
