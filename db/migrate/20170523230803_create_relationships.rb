class CreateRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :relationships do |t|
      t.string :name, null: false
      t.belongs_to :event
      t.boolean :universal, default: false
    end
  end
end
