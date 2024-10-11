# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.has_role?('admin')
      can :manage, Video
      can :manage, User
      can :update_role, User
    elsif user.has_role?('manager')
      can :manage, Video
    end

    can %i[destroy update], Video, user_id: user.id
    can %i[destroy update], User, id: user.id
  end
end
