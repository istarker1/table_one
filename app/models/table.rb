class Table < ApplicationRecord
  belongs_to :event
  has_many :guests
  has_many :plusones

  validates :table_number, :table_size_limit, presence: true
end