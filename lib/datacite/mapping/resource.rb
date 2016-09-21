require 'xml/mapping_extensions'

require 'datacite/mapping/identifier'
require 'datacite/mapping/creator'
require 'datacite/mapping/title'
require 'datacite/mapping/subject'
require 'datacite/mapping/contributor'
require 'datacite/mapping/date'
require 'datacite/mapping/resource_type'
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
      # @param identifier [Identifier] a persistent identifier that identifies a resource.
      # @param creators [Array<Creator>] the main researchers involved working on the data, or the authors of the publication in priority order.
      # @param titles [Array<Title>] the names or titles by which a resource is known.
      # @param publisher [String] the name of the entity that holds, archives, publishes prints, distributes, releases, issues, or produces the resource.
      # @param publication_year [Integer] year when the resource is made publicly available.
      # @param subjects [Array<Subject>] subjects, keywords, classification codes, or key phrases describing the resource.
      # @param funding_references [Array<FundingReference>] information about financial support (funding) for the resource being registered.
      # @param contributors [Array<Contributor>] institutions or persons responsible for collecting, creating, or otherwise contributing to the developement of the dataset.
      # @param dates [Array<Date>] different dates relevant to the work.
      # @param resource_type [ResourceType, nil] the type of the resource
      # @param alternate_identifiers [Array<AlternateIdentifier>] an identifier or identifiers other than the primary {Identifier} applied to the resource being registered.
      # @param related_identifiers [Array<RelatedIdentifier>] identifiers of related resources.
      # @param rights_list [Array<Rights>] rights information for this resource.
      # @param descriptions [Array<Description>] all additional information that does not fit in any of the other categories.
      # @param geo_locations [Array<GeoLocations>] spatial region or named place where the data was gathered or about which the data is focused.
      def initialize(identifier:, creators:, titles:, publisher:, publication_year:, subjects: [], contributors: [], dates: [], funding_references: [], resource_type: nil, alternate_identifiers: [], related_identifiers: [], rights_list: [], descriptions: [], geo_locations: []) # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists, Metrics/AbcSize
        self.identifier = identifier
        self.creators = creators
        self.titles = titles
        self.publisher = publisher
        self.publication_year = publication_year
        self.subjects = subjects
        self.funding_references = funding_references
        self.contributors = contributors
        self.dates = dates
        self.resource_type = resource_type
        self.alternate_identifiers = alternate_identifiers
        self.related_identifiers = related_identifiers
        self.rights_list = rights_list
        self.descriptions = descriptions
        self.geo_locations = geo_locations
      end

      def identifier=(value)
        fail ArgumentError, 'Resource must have an identifier' unless value
        @identifier = value
      end

      def creators=(value)
        fail ArgumentError, 'Resource must have at least one creator' unless value && value.size > 0
        @creators = value
      end

      def titles=(value)
        fail ArgumentError, 'Resource must have at least one title' unless value && value.size > 0
        @titles = value
      end

      def publisher=(value)
        new_value = value && value.strip
        fail ArgumentError, 'Resource must have at least one publisher' unless new_value && new_value.size > 0
        @publisher = new_value.strip
      end

      def publication_year=(value)
        fail ArgumentError, 'Resource must have a four-digit publication year' unless value && value.to_i.between?(1000, 9999)
        @publication_year = value.to_i
      end

      def subjects=(value)
        @subjects = (value && value.select(&:value)) || []
      end

      def contributors=(value)
        @contributors = value || []
      end

      def dates=(value)
        @dates = value || []
      end

      def funding_references=(value)
        @funding_references = value || []
      end

      def alternate_identifiers=(value)
        @alternate_identifiers = value || []
      end

      def related_identifiers=(value)
        @related_identifiers = value || []
      end

      def rights_list=(value)
        @rights_list = value || []
      end

      def descriptions=(value)
        @descriptions = (value && value.select(&:value)) || []
      end

      def geo_locations=(value)
        @geo_locations = (value && value.select(&:location?)) || []
      end

      # @!attribute [rw] identifier
      #   @return [Identifier] a persistent identifier that identifies a resource.
      object_node :identifier, 'identifier', class: Identifier

      # @!attribute [rw] creators
      #   @return [Array<Creator>] the main researchers involved working on the data, or the authors of the publication in priority order.
      array_node :creators, 'creators', 'creator', class: Creator

      # @!attribute [rw] titles
      #   @return [Array<Title>] the names or titles by which a resource is known.
      array_node :titles, 'titles', 'title', class: Title

      # @!attribute [rw] publisher
      #   @return [String] the name of the entity that holds, archives, publishes prints, distributes, releases, issues, or produces the resource.
      text_node :publisher, 'publisher'

      # @!attribute [rw] publication_year
      #   @return [Integer] year when the resource is made publicly available.
      numeric_node :publication_year, 'publicationYear'

      # @!attribute [rw] subjects
      #   @return [Array<Subject>] subjects, keywords, classification codes, or key phrases describing the resource.
      array_node :subjects, 'subjects', 'subject', class: Subject, default_value: []

      # @!attribute [rw] fundingReferences
      #   @return [Array<FundingReference>] information about financial support (funding) for the resource being registered.
      array_node :funding_references, 'fundingReferences', 'fundingReference', class: FundingReference, default_value: []

      # @!attribute [rw] contributors
      #   @return [Array<Contributor>] institutions or persons responsible for collecting, creating, or otherwise contributing to the developement of the dataset.
      array_node :contributors, 'contributors', 'contributor', class: Contributor, default_value: []

      # @!attribute [rw] dates
      #   @return [Array<Date>] different dates relevant to the work.
      array_node :dates, 'dates', 'date', class: Date, default_value: []

      # @!attribute [rw] resource_type
      #   @return [ResourceType, nil] the type of the resource. Optional.
      object_node :resource_type, 'resourceType', class: ResourceType, default_value: nil

      # @!attribute [rw] alternate_identifiers
      #   @return [Array<AlternateIdentifier>] an identifier or identifiers other than the primary {Identifier} applied to the resource being registered.
      array_node :alternate_identifiers, 'alternateIdentifiers', 'alternateIdentifier', class: AlternateIdentifier, default_value: []

      # @!attribute [rw] related_identifiers
      #   @return [Array<RelatedIdentifier>] identifiers of related resources.
      array_node :related_identifiers, 'relatedIdentifiers', 'relatedIdentifier', class: RelatedIdentifier, default_value: []

      # @!attribute [rw] rights_list
      #   @return [Array<Rights>] rights information for this resource.
      array_node :rights_list, 'rightsList', 'rights', class: Rights, default_value: []

      # @!attribute [rw] descriptions
      #   @return [Array<Description>] all additional information that does not fit in any of the other categories.
      array_node :descriptions, 'descriptions', 'description', class: Description, default_value: []

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

      # Convenience method to get the funding contributor.
      # @return [Contributor, nil] the contributor of type FUNDER, if any.
      def funder_contrib
        contributors.find { |c| c.type == ContributorType::FUNDER }
      end

      # Convenience method to get the name of the funding contributor.
      # @deprecated contributor type 'funder' is deprecated. Use {FundingReference} instead.
      # @return [String, nil] the name of the funding contributor, if any.
      def funder_name
        funder_contrib.name if funder_contrib
      end

      # Convenience method to get the funding contributor identifier.
      # @return [NameIdentifier, nil] the identifier of the funding contributor, if any.
      def funder_id
        funder_contrib.identifier if funder_contrib
      end

      # Convenience method to get the funding contributor identifier as a string.
      # @return [String, nil] the string value of the funding contributor's identifier, if any.
      def funder_id_value
        funder_id.value if funder_id
      end

      extend Gem::Deprecate
      deprecate(:funder_contrib, FundingReference, 2016, 9)
      deprecate(:funder_name, FundingReference, 2016, 9)
      deprecate(:funder_id, FundingReference, 2016, 9)
      deprecate(:funder_id_value, FundingReference, 2016, 9)

      use_mapping :datacite_3
      fallback_mapping :datacite_3, :_default
    end

  end
end
