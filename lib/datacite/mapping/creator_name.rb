# frozen_string_literal: true

require 'xml/mapping'
require 'datacite/mapping/read_only_nodes'
require 'datacite/mapping/name_identifier'
require 'datacite/mapping/creator_name'

module Datacite
  module Mapping

    # Controlled vocabulary of title types (for titles other than the main/default title).
    class NameType < TypesafeEnum::Base
      # @!parse ORGANIZATIONAL = Organizational
      new :ORGANIZATIONAL, 'Organizational'

      # @!parse PERSONAL = Personal
      new :PERSONAL, 'Personal'
    end
    

    class CreatorName
      include XML::Mapping
      def initialize(type: nil, value:)
        self.type = type
        self.value = value
      end

      def value=(value)
        new_value = value&.strip
        raise ArgumentError, 'Value cannot be empty or nil' unless new_value && !new_value.empty?

        @value = new_value.strip
      end

      # @!attribute [rw] type
      #   @return [NameType, nil] the name type. Optional.
      typesafe_enum_node :type, '@nameType', class: NameType, default_value: nil

      # @!attribute [rw] value
      #   @return [String] the name itself.
      text_node :value, 'text()'
    end
  end
end
