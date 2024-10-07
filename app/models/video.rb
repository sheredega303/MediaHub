class Video < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 255 }
  validates :age_rating, presence: true, inclusion: { in: %w[G PG PG-13 R NC-17] }
  validates :duration, presence: true
end
