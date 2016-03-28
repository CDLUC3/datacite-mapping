require 'xml/mapping_extensions'

module Datacite
  module Mapping

    # An identifier or identifiers other than the primary {Identifier}
    # applied to the {Resource}.
    class AlternateIdentifier
      include XML::Mapping

      # Initializes a new {AlternateIdentifier}
      # @param type [String] the identifier type
      # @param value [String] the identifier value
      def initialize(type:, value:)
        self.type = type
        self.value = value
      end

      # Sets the type. Cannot be nil.
      # @param val [String] the identifier type
      def type=(val)
        fail ArgumentError, 'No identifier type provided' unless val
        @type = val
      end

      # Sets the value. Cannot be nil.
      # @param val [String] the value
      def value=(val)
        fail ArgumentError, 'No identifier value provided' unless val
        @value = val
      end

      root_element_name 'alternateIdentifier'
      text_node :type, '@alternateIdentifierType'
      text_node :value, 'text()'
    end
  end
end
