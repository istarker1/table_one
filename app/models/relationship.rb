class Relationship < ApplicationRecord
  belongs_to :event
  has_many :guests

  validates :name, presence: true
end
