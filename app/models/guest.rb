class Guest < ApplicationRecord
  has_one :relationship
  belongs_to :event

  validates :first_name, :last_name, :side, :relationship_id, :event, presence: true
end
