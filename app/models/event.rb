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
    rel.shift
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

  def event_tables
    Table.where(event_id: id)
  end

  # ----- seating arrangement building methods -----

  def create_tables
    x = 1
    table_count = (all_guests.length / table_size_limit.to_f).ceil
    while x <= table_count
      Table.create(table_number: x, table_size_limit: table_size_limit, event_id: id)
      x += 1
    end
  end

  def create_arrangement
    a, b = side_a_guests.to_a, side_b_guests.to_a
    all_tables, all_relationships = tables, relationships  # self.tables / self.relationships
    sort_immediate_family(a)
    sort_immediate_family(b)
    binding.pry
    # all_tables.each do |t|
    #   relationships.each do |r|
    #     x = []
    #     side_a_guests.each do |g|
    #     end
    #   end
    # end

  end

  def sort_immediate_family(side)
    event_tables.each do |t|          # WHY DOESN'T JUST `tables` WORK???
      # binding.pry
      if t.empty?
        side.delete_if do |guest|
          if (guest.relationship.id == relationships[0][1] || # mother / father
          guest.relationship.id == relationships[1][1] ||       # grandparents
          guest.relationship.id == relationships[2][1] ||         # grandparents
          guest.relationship.id == relationships[3][1] ||
          guest.relationship.id == relationships[4][1]) &&
            t.guests.length + t.plusones.length <= t.table_size_limit
            if !guest.nil?
              guest.update(table_id: t.id)
              guest.plusones.each do |p1|
                p1.update(table_id: t.id)
              end                     # guest.plusones.each do
            end                       # if !guest.nil?
          end                         # if .relationship[...] && < size_limit
        end                           # a.delete_if do
      end                             # if t.empty?
    end                               # tables.each do
  end                                 # sort_immediate_family(side_)

end







# Select table one
# Find side_a guests with select relationship(s)
# Pop them into table one while less than table_size_limit
# Fide side_b guests with select relationship(s)
# Pop them into next table while less than table_size_limit
#   If guests with select relationship is greater than table_size_limit
#   Move on to next table
