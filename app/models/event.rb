class Event < ApplicationRecord
  has_many :hosts
  has_many :users, through: :hosts
  has_many :guests

  validates :name, :table_size_limit, presence: true

  def host_names
    users.map { |e| e.first_name }.join(", ")
  end

  def find_side_a
    Couple.find(side_a)
  end

  def find_side_b
    Couple.find(side_b)
  end

  def sides
    [find_side_a, find_side_b]
  end

  def relationships
    rel = []
    Relationship.where(universal: true).map { |e| rel << [e.name, e.id]  }
    Relationship.where(event_id: id).map { |e| rel << [e.name, e.id]  }
    rel
  end

end
