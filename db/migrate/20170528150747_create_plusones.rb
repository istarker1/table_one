class CreatePlusones < ActiveRecord::Migration[5.0]
  def change
    create_table :plusones do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.belongs_to :guest
      t.text :notes
    end
  end
end
