# frozen_string_literal: true

require 'xml/mapping'
require 'datacite/mapping/read_only_nodes'

module Datacite
  module Mapping

    # Controlled vocabulary of name types
    class NameType < TypesafeEnum::Base
      # @!parse ORGANIZATIONAL = Organizational
      new :ORGANIZATIONAL, 'Organizational'

      # @!parse PERSONAL = Personal
      new :PERSONAL, 'Personal'
    end
  end
end
