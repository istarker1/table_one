class Plusone < ApplicationRecord
  belongs_to :guest
  belongs_to :event
  belongs_to :table

  validates :first_name, :last_name, presence: true

end
