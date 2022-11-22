class Car < ApplicationRecord
  belongs_to :model
  has_many :ad, dependent: :destroy
  validates :model, presence: true
  validates :creation_year, presence: true
  validates :engine_capacity, presence: true
end
