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
      # @param geo_locations [Array<GeoLocations>] spatial region or named place where the data was gathered or about which the data is focused.
      def initialize(creators:, alternate_identifiers: [], geo_locations: []) # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists, Metrics/AbcSize
        self.creators = creators
        self.alternate_identifiers = alternate_identifiers
        self.geo_locations = geo_locations
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

      # @!attribute [rw] geo_locations
      #   @return [Array<GeoLocations>] spatial region or named place where the data was gathered or about which the data is focused.
      array_node :geo_locations, 'geoLocations', 'geoLocation', class: GeoLocation, default_value: []

      # Convenience method to get the creators' names.
      # @return [[Array[String]] An array of the creators' names.
      def creator_names
        creators.map(&:name)
      end

      # Convenience method to get the creators' affiliations. (Bear in mind that each creator
      # can have multiple affiliations.)
      # @return [Array[Array[String]]] An array containing each creator's array of affiliations.
      def creator_affiliations
        creators.map(&:affiliations)
      end

    end

  end
end
