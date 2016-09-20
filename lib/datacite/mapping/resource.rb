require 'xml/mapping_extensions'

module Datacite
  module Mapping

    # A collection of metadata properties chosen for the accurate and consistent identification
    # of a resource for citation and retrieval purposes, along with recommended use instructions.
    # The resource that is being identified can be of any kind, but it is typically a dataset.
    class Resource # rubocop:disable Metrics/ClassLength
      include XML::MappingExtensions::Namespaced

      # Initialies a new {Resource}
      #
      # @param creators [Array<Creator>] the main researchers involved working on the data, or the authors of the publication in priority order.
      # @param alternate_identifiers [Array<AlternateIdentifier>] an identifier or identifiers other than the primary {Identifier} applied to the resource being registered.
      def initialize(creators:, alternate_identifiers: []) # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists, Metrics/AbcSize
        self.creators = creators
        self.alternate_identifiers = alternate_identifiers
      end

      def creators=(value)
        fail ArgumentError, 'Resource must have at least one creator' unless value && value.size > 0
        @creators = value
      end

      # @!attribute [rw] creators
      #   @return [Array<Creator>] the main researchers involved working on the data, or the authors of the publication in priority order.
      array_node :creators, 'creators', 'creator', class: Creator

      # @!attribute [rw] alternate_identifiers
      #   @return [Array<AlternateIdentifier>] an identifier or identifiers other than the primary {Identifier} applied to the resource being registered.
      array_node :alternate_identifiers, 'alternateIdentifiers', 'alternateIdentifier', class: AlternateIdentifier, default_value: []
    end

  end
end
