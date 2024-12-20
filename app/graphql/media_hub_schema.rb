# frozen_string_literal: true

class MediaHubSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  # For batch-loading (see https://graphql-ruby.org/dataloader/overview.html)
  use GraphQL::Dataloader

  max_query_string_tokens(5000)
  validate_max_errors(100)

  class << self
    # GraphQL-Ruby calls this when something goes wrong while running a query:
    # def type_error(err, context)
    #   # if err.is_a?(GraphQL::InvalidNullError)
    #   #   # report to your bug tracker here
    #   #   return nil
    #   # end
    #   super
    # end

    # Union and Interface Resolution
    def resolve_type(_abstract_type, _obj, _ctx)
      # TODO: Implement this method
      # to return the correct GraphQL object type for `obj`
      raise(GraphQL::RequiredImplementationMissingError)
    end

    # Return a string UUID for `object`
    def id_from_object(object, _type_definition, _query_ctx)
      # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
      object.to_gid_param
    end

    # Given a string UUID, find the object
    def object_from_id(global_id, _query_ctx)
      # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
      GlobalID.find(global_id)
    end
  end
end
