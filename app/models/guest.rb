class Guest < ApplicationRecord
  belongs_to :relationship
  belongs_to :event
  has_many :plusones
  belongs_to :table

  validates :first_name, :last_name, :side, :relationship_id, :event, presence: true

  def guest_side
    Couple.find(side)
  end

  def guest_relationship
    Relationship.find(relationship_id)
  end
end
