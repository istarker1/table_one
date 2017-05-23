class CreateEventUserJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_join_table :events, :users, table_name: :hosts
  end
end
