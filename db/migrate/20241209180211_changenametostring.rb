class Changenametostring < ActiveRecord::Migration[8.0]
  def change
    change_column :categories, :name, :string
  end
end
