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
      # @param alternate_identifiers [Array<AlternateIdentifier>] an identifier or identifiers other than the primary {Identifier} applied to the resource being registered.
      def initialize(alternate_identifiers: [])
        self.alternate_identifiers = alternate_identifiers
      end

      # @!attribute [rw] alternate_identifiers
      #   @return [Array<AlternateIdentifier>] an identifier or identifiers other than the primary {Identifier} applied to the resource being registered.
      array_node :alternate_identifiers, 'alternateIdentifiers', 'alternateIdentifier', class: AlternateIdentifier, default_value: []
    end

  end
end
