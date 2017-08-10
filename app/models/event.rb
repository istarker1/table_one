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
    # rel.shift         # removing "Choose one or create your own"
    rel
  end

  def non_universal_relationships
    Relationship.where(event_id: id)
  end

  def all_guests
    all = []
    guests.each do |guest|
      all << guest
      guest.plusones.map { |plusone| all << plusone  } if guest.plusones != []
    end
    all
  end

  def guest_count
    all_guests.count
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
    combine_tables
    sort_siblings_and_cousins(a)
    sort_siblings_and_cousins(b)
    combine_tables
    sort_wedding_party(a)
    sort_wedding_party(b)
    combine_tables
    sort_non_universal_relationships(a)
    sort_non_universal_relationships(b)
    delete_empty_tables
    combine_small_tables
    delete_empty_tables
  end

#============

  def create_tables(count, tables)
    last_table = Table.where(event_id: id)
    last_table = [] ? (last_table_id = 0) : last_table_id = last_table.last.id
    (count / table_size_limit.to_f).ceil.times do
      tables << Table.create(table_number: last_table_id + 1, table_size_limit: table_size_limit, event_id: id)
      last_table_id += 1
    end
    tables
  end

  def sort_tables(tables, group)
    tables.each do |t|
      while !group.empty? && Table.find(t.id).count + group[0].count <= t.table_size_limit
        guest = group.shift
        guest.update(table_id: t.id)
        guest.plusones.each do |p1|
          p1.update(table_id: t.id)
        end
      end
    end
  end

  def sort_immediate_family(side)
    group, tables = [], []
    count = 0
    side.delete_if do |guest|
      if guest.relationship.id == relationships[1][1] || # mother / father
      guest.relationship.id == relationships[2][1] ||    # grandparents
      guest.relationship.id == relationships[3][1] ||    # grandparents
      guest.relationship.id == relationships[4][1] ||    # aunt / uncle
      guest.relationship.id == relationships[5][1]       # aunt / uncle
        group << guest
        count += guest.count
      end
    end
    create_tables(count, tables)
    sort_tables(tables, group)
  end

  def sort_siblings_and_cousins(side)
    group, tables = [], []
    count = 0
    side.delete_if do |guest|
      if guest.relationship.id == relationships[6][1] || # brother / sister
      guest.relationship.id == relationships[7][1] ||       # cousins
      guest.relationship.id == relationships[8][1]
        group << guest
        count += guest.count
      end
    end
    create_tables(count, tables)
    sort_tables(tables, group)
  end

  def sort_wedding_party(side)
    group, tables = [], []
    count = 0
    side.delete_if do |guest|
      if guest.relationship.id == relationships[9][1]
        group << guest
        count += guest.count
      end
    end
    create_tables(count, tables)
    sort_tables(tables, group)
  end

  def sort_non_universal_relationships(side)
    non_universal_relationships.each do |rel|
      group, tables = [], []
      count = 0
      side.delete_if do |guest|
        if guest.relationship.id == rel.id
          group << guest
          count += guest.count
        end
      end
      create_tables(count, tables)
      sort_tables(tables, group)
    end
    # combine_tables
  end

#============

  def combine_tables
    from = Table.where(event_id: id)[-1]
    to = Table.where(event_id: id)[-2]
    if from.count != 0 && to.count!= 0 && from.count + to.count <= table_size_limit
      from.guests.each do |guest|
        guest.update(table_id: to.id)
        guest.plusones.each do |p1|
          p1.update(table_id: to.id)
        end
      end
      from.delete
    end
  end

  def delete_empty_tables
    event_tables.reverse_each do |t|
      t.delete if t.empty?
    end
  end

  def combine_small_tables
    done = false # for combining loop
    small_tables = []
    tables.each { |t| small_tables << t if t.small? == true  }
    done = true if small_tables.empty?
    done = true if small_tables.count == 1
    while done == false
      from = small_tables.pop
      to = small_tables.pop
      from.guests.each do |guest|
        guest.update(table_id: to.id)
        guest.plusones.each do |p1|
          p1.update(table_id: to.id)
        end
      end
    done = true if small_tables.empty?
    done = true if small_tables.count == 1
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
