class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  self.table_name = 'jwt_denylist'

  def self.revoked?(token)
    record = find_by(jti: token)
    record.present? && record.exp > Time.current
  end
end
