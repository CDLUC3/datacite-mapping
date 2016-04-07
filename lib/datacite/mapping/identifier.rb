require 'xml/mapping'

module Datacite
  module Mapping
    DOI_PATTERN = %r{10\..+/.+}

    # The persistent identifier that identifies the resource.
    #
    # @!attribute [r] identifier_type
    #   @return [String] the identifier type (always 'DOI')
    # @!attribute [rw] value
    #   @return [String] the identifier value. Must be a valid DOI value (`10.`_registrant code_`/`_suffix_)
    class Identifier
      include XML::Mapping

      # Initializes a new {Identifier}
      # @param value [String]
      #   the identifier value. Must be a valid DOI value (`10.`_registrant code_`/`_suffix_)
      def initialize(value:)
        self.identifier_type = 'DOI'
        self.value = value
      end

      def value=(v)
        fail ArgumentError, "Identifier value '#{v}' is not a valid DOI" unless v.match(DOI_PATTERN)
        @value = v
      end

      # Sets the identifier type. Should only be called by the XML mapping engine.
      # @param v [String]
      #   the identifier type (always 'DOI')
      def identifier_type=(v)
        fail ArgumentError, "Identifier type '#{v}' must be 'DOI'" unless 'DOI' == v
        @identifier_type = v
      end

      # Converts a string DOI value to an `Identifier`.
      # @param doi_string [String]
      def self.from_doi(doi_string)
        match = doi_string.match(DOI_PATTERN)
        fail ArgumentError, "'#{doi_string}' does not appear to contain a valid DOI" unless match
        Identifier.new(value: match[0])
      end

      text_node :identifier_type, '@identifierType'
      text_node :value, 'text()'
    end
  end
end
