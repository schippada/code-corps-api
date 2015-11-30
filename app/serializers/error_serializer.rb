class ErrorSerializer
  def self.serialize(error)
    error_hash = serialize_doorkeeper_oauth_invalid_token_response(error) if error.class == Doorkeeper::OAuth::InvalidTokenResponse
    error_hash = serialize_doorkeeper_oauth_error_response(error) if error.class == Doorkeeper::OAuth::ErrorResponse
    error_hash = serialize_cancan_access_denied(error) if error.class == CanCan::AccessDenied
    error_hash = serialize_validation_errors(error) if error.class == ActiveModel::Errors

    { errors: Array.wrap(error_hash) }
  end

  private

    def self.serialize_doorkeeper_oauth_invalid_token_response(error)
      return {
        id: "NOT_AUTHORIZED",
        title: "Not authorized",
        detail: error.description,
        status: 401
      }
    end

    def self.serialize_doorkeeper_oauth_error_response(error)
      return {
        id: "INVALID_GRANT",
        title: "Invalid grant",
        detail: error.description,
        status: 401
      }
    end

    def self.serialize_cancan_access_denied(error)
      action_name = error.action.to_s.pluralize
      subject_name = error.subject.class.to_s.downcase
      return {
        id: "ACCESS_DENIED",
        title: "Access denied",
        detail: "You are not authorized to perform #{action_name} on this #{subject_name}.",
        status: 401
      }
    end

    def self.serialize_validation_errors(errors)
      errors.to_hash(true).map do |k, v|
        v.map do |msg|
          { id: "VALIDATION_ERROR", title: "#{k.capitalize} error", detail: msg, status: 422 }
        end
      end.flatten
    end
end
