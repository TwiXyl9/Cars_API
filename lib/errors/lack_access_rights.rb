module Errors
  class LackAccessRights < StandardError
    def message
      "You haven't rights for this resource!"
    end
  end
end
