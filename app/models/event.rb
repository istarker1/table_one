class Event < ApplicationRecord
  has_many :hosts
  has_many :users, through: :hosts

  validates :name, :table_size_limit, presence: true

  def host_names
    users.map { |e| e.first_name }.join(", ")
  end
end
