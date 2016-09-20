require 'xml/mapping_extensions'

require 'datacite/mapping/creator'
require 'datacite/mapping/subject'
require 'datacite/mapping/alternate_identifier'
require 'datacite/mapping/rights'
require 'datacite/mapping/geo_location'

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
      # @param subjects [Array<Subject>] subjects, keywords, classification codes, or key phrases describing the resource.
      # @param alternate_identifiers [Array<AlternateIdentifier>] an identifier or identifiers other than the primary {Identifier} applied to the resource being registered.
      # @param rights_list [Array<Rights>] rights information for this resource.
      # @param geo_locations [Array<GeoLocations>] spatial region or named place where the data was gathered or about which the data is focused.
      def initialize(creators:, subjects: [], alternate_identifiers: [], rights_list: [], geo_locations: []) # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists, Metrics/AbcSize
        self.creators = creators
        self.subjects = subjects
        self.alternate_identifiers = alternate_identifiers
        self.rights_list = rights_list
        self.geo_locations = geo_locations
      end

      def creators=(value)
        fail ArgumentError, 'Resource must have at least one creator' unless value && value.size > 0
        @creators = value
      end

      # @!attribute [rw] creators
      #   @return [Array<Creator>] the main researchers involved working on the data, or the authors of the publication in priority order.
      array_node :creators, 'creators', 'creator', class: Creator

      def subjects=(value)
        @subjects = (value && value.select(&:value)) || []
      end

      # @!attribute [rw] subjects
      #   @return [Array<Subject>] subjects, keywords, classification codes, or key phrases describing the resource.
      array_node :subjects, 'subjects', 'subject', class: Subject, default_value: []

      def alternate_identifiers=(value)
        @alternate_identifiers = value || []
      end

      # @!attribute [rw] alternate_identifiers
      #   @return [Array<AlternateIdentifier>] an identifier or identifiers other than the primary {Identifier} applied to the resource being registered.
      array_node :alternate_identifiers, 'alternateIdentifiers', 'alternateIdentifier', class: AlternateIdentifier, default_value: []

      def rights_list=(value)
        @rights_list = value || []
      end

      # @!attribute [rw] rights_list
      #   @return [Array<Rights>] rights information for this resource.
      array_node :rights_list, 'rightsList', 'rights', class: Rights, default_value: []

      def geo_locations=(value)
        @geo_locations = (value && value.select(&:has_location?)) || []
      end

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

      use_mapping :datacite_3
      fallback_mapping :datacite_3, :_default

    end

  end
end
