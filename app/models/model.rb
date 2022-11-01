class Model < ApplicationRecord
  belongs_to :brand
  has_many :cars
  validates :name, presence: true, uniqueness: true
end
