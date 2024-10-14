class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable

  validates :channel_name, length: { maximum: 100 }

  has_many :videos, dependent: :destroy
end
