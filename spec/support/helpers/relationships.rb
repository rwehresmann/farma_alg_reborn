module Helpers
  module Relationships
    # Returns the relationship type between the model
    # (class name capitalized, like User) and its associated_model
    # (symbol format).
    def relationship_type(model, associated_model)
      model.reflect_on_association(associated_model).macro
    end
  end
end
