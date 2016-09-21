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

      DOI = 'DOI'.freeze

      # Initializes a new {Identifier}
      # @param value [String]
      #   the identifier value. Must be a valid DOI value (`10.`_registrant code_`/`_suffix_)
      def initialize(value:)
        self.identifier_type = DOI
        self.value = value
      end

      def value=(v)
        fail ArgumentError, 'Identifier must have a non-nil value' unless v
        fail ArgumentError, "Identifier value '#{v}' is not a valid DOI" unless v.match(DOI_PATTERN)
        @value = v
      end

      # Sets the identifier type. Should only be called by the XML mapping engine.
      # @param v [String]
      #   the identifier type (always 'DOI')
      def identifier_type=(v)
        fail ArgumentError, "Identifier type '#{v}' must be 'DOI'" unless DOI == v
        @identifier_type = v
      end

      # Gets the identifiery type.
      def identifier_type
        @identifier_type ||= DOI
      end

      # Converts a string DOI value to an `Identifier`.
      # @param doi_string [String]
      def self.from_doi(doi_string)
        match = doi_string.match(DOI_PATTERN)
        fail ArgumentError, "'#{doi_string}' does not appear to contain a valid DOI" unless match
        Identifier.new(value: match[0])
      end

      def self.extract_and_set_value(obj, xml)
        obj.value = xml.text
      end
      private_class_method :extract_and_set_value

      text_node :identifier_type, '@identifierType'

      # The default reader throws an opaque XPath error if there's no element text,
      # so we extract it manually and let the accessor raise an error instead
      text_node :value, 'text()', reader: method(:extract_and_set_value)

      fallback_mapping :datacite_3, :_default
    end
  end
end
