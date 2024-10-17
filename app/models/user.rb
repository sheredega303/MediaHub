class User < ApplicationRecord
  rolify

  after_create :assign_default_role

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  validates :channel_name, length: { maximum: 100 }

  has_many :videos, dependent: :destroy

  private

  def assign_default_role
    add_role(:member) if roles.blank?
  end
end
