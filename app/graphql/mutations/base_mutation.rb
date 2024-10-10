# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    def authorize!(action, record)
      ability = Ability.new(context[:current_user])
      raise GraphQL::ExecutionError, I18n.t('no_access') unless ability.can?(action, record)
    end
  end
end
