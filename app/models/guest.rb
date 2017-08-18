class Guest < ApplicationRecord
  belongs_to :relationship
  belongs_to :event
  has_many :plusones, dependent: :destroy
  belongs_to :table

  validates :first_name, :last_name, :side, :relationship_id, :event, presence: true

  def guest_side
    Couple.find(side)
  end

  def guest_relationship
    Relationship.find(relationship_id)
  end

  def count
    1 + plusones.length
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def guest_saver

  end

end
