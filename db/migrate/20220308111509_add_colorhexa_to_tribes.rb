class AddColorhexaToTribes < ActiveRecord::Migration[6.1]
  def change
    add_column :tribes, :colorhexa, :string
  end
end
