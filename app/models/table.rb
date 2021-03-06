class Table < ApplicationRecord
  belongs_to :event
  has_many :guests
  has_many :plusones

  validates :table_number, :table_size_limit, presence: true

  def empty?
    guests.length + plusones.length == 0
  end

  def all
    guests + plusones
  end

  def count
    all.length
  end

  def small?
    count <= table_size_limit / 2
  end

end
