class Event < ApplicationRecord
  has_many :hosts
  has_many :users, through: :hosts
  has_many :guests
  has_many :tables
  has_many :plusones

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

  def all_guests
    all = []
    guests.each do |guest|
      all << guest
      guest.plusones.map { |plusone| all << plusone  } if guest.plusones != []
    end
    all
  end

  def side_a_guests
    Guest.where(side: side_a)
  end

  def side_b_guests
    Guest.where(side: side_b)
  end

  # ----- seating arrangement building methods -----

  def create_tables
    x = 1
    table_count = (all_guests.length / table_size_limit.to_f).ceil
    while x <= table_count
      Table.create(table_number: x, table_size_limit: table_size_limit, event_id: self)
      x += 1
    end
  end

  def create_arrangement
    side_a = side_a_guests
    side_b = side_b_guests
    all_tables = tables       # self.tables
    all_tables.each do |t|
      relationships.each do |r|

      end
    end

  end

end







# Select table one
# Find side_a guests with select relationship(s)
# Pop them into table one while less than table_size_limit
# Fide side_b guests with select relationship(s)
# Pop them into next table while less than table_size_limit
#   If guests with select relationship is greater than table_size_limit
#   Move on to next table
