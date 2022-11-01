class Ad < ApplicationRecord
  belongs_to :user
  belongs_to :car
  has_many_attached :photos
  enum stage: [:draft, :pending, :rejected, :published, :archival]

end
