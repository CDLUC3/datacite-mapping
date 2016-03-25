require 'xml/mapping'

module Datacite
  module Mapping
    # The persistent identifier that identifies the resource.
    #
    # @!attribute [r] identifier_type
    #   @return [String] the identifier type (always 'DOI')
    # @!attribute [rw] value
    #   @return [String] the identifier value. Must be a valid DOI value (`10.`_registrant code_`/`_suffix_)
    class Identifier
      include XML::Mapping

      text_node :identifier_type, '@identifierType'
      text_node :value, 'text()'

      # Initializes a new {Identifier}
      # @param value [String]
      #   the identifier value. Must be a valid DOI value (`10.`_registrant code_`/`_suffix_)
      def initialize(value:)
        self.identifier_type = 'DOI'
        self.value = value
      end

      maybe_alias :_value=, :value=
      private :_value=

      maybe_alias :_identifier_type=, :identifier_type=
      private :_identifier_type=

      def value=(v)
        fail ArgumentError, "Identifier value '#{v}' is not a valid DOI" unless v.match(%r{10\..+/.+})
        self._value = v
      end

      # Sets the identifier type. Should only be called by the XML mapping engine.
      # @param v [String]
      #   the identifier type (always 'DOI')
      def identifier_type=(v)
        fail ArgumentError, "Identifier type '#{v}' must be 'DOI'" unless 'DOI' == v
        self._identifier_type = v
      end
    end
  end
end
