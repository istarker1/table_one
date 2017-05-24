class CreateCouples < ActiveRecord::Migration[5.0]
  def change
    create_table :couples do |t|
        t.string :first_name, null: false
        t.string :last_name, null: false
        t.text :notes
        t.belongs_to :event, null: false
    end
  end
end
