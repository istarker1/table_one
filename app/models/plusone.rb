class Plusone < ApplicationRecord
  belongs_to :guest

  validates :first_name, :last_name, presence: true

end
