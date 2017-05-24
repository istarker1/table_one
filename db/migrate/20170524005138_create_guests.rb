class CreateGuests < ActiveRecord::Migration[5.0]
  def change
    create_table :guests do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :side, null: false
      t.text :notes
      t.belongs_to :relationship, null: false
      t.belongs_to :event, null: false
    end
  end
end
