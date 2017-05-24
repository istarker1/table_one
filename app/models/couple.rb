class Couple < ApplicationRecord
  belongs_to :event
  has_many :guests, through: :event

  validates :first_name, :last_name, :event, presence: true
end
