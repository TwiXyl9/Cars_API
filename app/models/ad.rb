class Ad < ApplicationRecord
  belongs_to :user
  belongs_to :car
  has_many_attached :photos
  enum stage: [:draft, :pending, :rejected, :published, :archival]
  after_initialize :set_default_stage, :if => :new_record?

  private
  def set_default_stage
    self.stage ||= :draft
  end
end
