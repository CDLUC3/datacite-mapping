# frozen_string_literal: true

require 'xml/mapping'
require 'datacite/mapping/empty_filtering_nodes'

module Datacite
  module Mapping
    DOI_PATTERN = %r{10\.\S+/\S+}.freeze

    # The persistent identifier that identifies the resource.
    #
    # @!attribute [r] identifier_type
    #   @return [String] the identifier type (always 'DOI')
    # @!attribute [rw] value
    #   @return [String] the identifier value. Must be a valid DOI value (`10.`_registrant code_`/`_suffix_)
    class Identifier
      include XML::Mapping

      DOI = 'DOI'

      # Initializes a new {Identifier}
      # @param value [String]
      #   the identifier value. Must be a valid DOI value (`10.`_registrant code_`/`_suffix_)
      def initialize(value:)
        self.identifier_type = DOI
        self.value = value
      end

      def value=(new_value)
        new_value = new_value&.strip
        raise ArgumentError, 'Identifier must have a non-nil value' unless new_value
        raise ArgumentError, "Identifier value '#{new_value}' is not a valid DOI" unless new_value.match?(DOI_PATTERN)

        @value = new_value
      end

      # Sets the identifier type. Should only be called by the XML mapping engine.
      # @param new_value [String]
      #   the identifier type (always 'DOI')
      def identifier_type=(new_value)
        raise ArgumentError, "Identifier type '#{new_value}' must be 'DOI'" unless DOI == new_value

        @identifier_type = new_value
      end

      # Gets the identifiery type.
      def identifier_type
        @identifier_type ||= DOI
      end

      # Converts a string DOI value to an `Identifier`.
      # @param doi_string [String]
      def self.from_doi(doi_string)
        match = doi_string.match(DOI_PATTERN)
        raise ArgumentError, "'#{doi_string}' does not appear to contain a valid DOI" unless match

        Identifier.new(value: match[0])
      end

      text_node :value, 'text()'
      text_node :identifier_type, '@identifierType'

      fallback_mapping :datacite_3, :_default
    end

    # Custom node to warn (but not blow up) if we read an XML `<resource/>` that's
    # missing its `<identifier/>`.
    class IdentifierNode < XML::Mapping::ObjectNode
      include EmptyNodeUtils
      def xml_to_obj(_obj, xml)
        return super if (element = has_element?(xml)) && not_empty(element)

        warn 'Identifier not found; add a valid Identifier to the Resource before saving'
      end

      private

      def has_element?(xml) # rubocop:disable Naming/PredicateName
        @path.first(xml)
      rescue XML::XXPathError
        false
      end
    end
    XML::Mapping.add_node_class IdentifierNode
  end
end
