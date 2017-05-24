class AddGuestRefToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :side_a, :integer
    add_column :events, :side_b, :integer
  end
end
