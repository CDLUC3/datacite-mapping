require 'xml/mapping_extensions'

module Datacite
  module Mapping
    class AlternateIdentifier
      include XML::Mapping

      root_element_name 'alternateIdentifier'

      text_node :_type, '@alternateIdentifierType'
      text_node :_value, 'text()'

      def initialize(type:, value:)
        self.type = type
        self.value = value
      end

      def type
        _type
      end

      def type=(val)
        fail ArgumentError, 'No identifier type provided' unless val
        self._type = val
      end

      def value
        _value
      end

      def value=(val)
        fail ArgumentError, 'No identifier value provided' unless val
        self._value = val
      end
    end

    # Not to be instantiated directly -- just call `Resource#alternate_identifiers`
    class AlternateIdentifiers
      include XML::Mapping

      array_node :alternate_identifiers, 'alternateIdentifier', class: AlternateIdentifier

      def initialize(alternate_identifiers:)
        self.alternate_identifiers = alternate_identifiers || []
      end
    end
  end
end
