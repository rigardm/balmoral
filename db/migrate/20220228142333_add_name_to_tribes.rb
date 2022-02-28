class AddNameToTribes < ActiveRecord::Migration[6.1]
  def change
    add_column :tribes, :name, :string
  end
end
