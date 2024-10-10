# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can %i[destroy update], Video, user_id: user.id
    can %i[destroy update], User, id: user.id
  end
end
