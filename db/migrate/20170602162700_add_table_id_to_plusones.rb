class AddTableIdToPlusones < ActiveRecord::Migration[5.0]
  def change
    add_column :plusones, :table_id, :integer
  end
end
