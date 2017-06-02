class CreateTables < ActiveRecord::Migration[5.0]
  def change
    create_table :tables do |t|
      t.integer :table_number, null: false
      t.integer :table_size_limit, null: false
      t.belongs_to :event
    end

    add_column :guests, :table_id, :integer
  end
end
