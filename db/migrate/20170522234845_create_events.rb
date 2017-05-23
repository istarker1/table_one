class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.integer :table_size_limit, null: false

      t.timestamps
    end
  end
end
