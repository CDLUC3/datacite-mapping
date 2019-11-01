# frozen_string_literal: true

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
require 'datacite/mapping/read_only_nodes'

module Datacite
  module Mapping

    # A collection of metadata properties chosen for the accurate and consistent identification
    # of a resource for citation and retrieval purposes, along with recommended use instructions.
    # The resource that is being identified can be of any kind, but it is typically a dataset.
    class Resource # rubocop:disable Metrics/ClassLength
      include XML::MappingExtensions::Namespaced

      # Shadows Namespaced::ClassMethods.namespace
      def namespace
        @namespace ||= DATACITE_4_NAMESPACE
      end

      # Overrides Namespaced::InstanceMethods.fill_into_xml to check mapping
      def fill_into_xml(xml, options = { mapping: :_default })
        current_namespace = namespace
        return super if options[:mapping] != :datacite_3 || current_namespace.uri == DATACITE_3_NAMESPACE.uri

        begin
          @namespace = DATACITE_3_NAMESPACE.with_prefix(current_namespace.prefix)
          super
        ensure
          @namespace = current_namespace
        end
      end

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
      # @param language [String, nil] Primary language of the resource: an IETF BCP 47, ISO 639-1 language code.
      # @param resource_type [ResourceType, nil] the type of the resource
      # @param alternate_identifiers [Array<AlternateIdentifier>] an identifier or identifiers other than the primary {Identifier} applied to the resource being registered.
      # @param related_identifiers [Array<RelatedIdentifier>] identifiers of related resources.
      # @param sizes [Array<String>] unstructured size information about the resource.
      # @param formats [Array<String>] technical format of the resource, e.g. file extension or MIME type.
      # @param version [String] version number of the resource.
      # @param rights_list [Array<Rights>] rights information for this resource.
      # @param descriptions [Array<Description>] all additional information that does not fit in any of the other categories.
      # @param geo_locations [Array<GeoLocations>] spatial region or named place where the data was gathered or about which the data is focused.
      def initialize(identifier:, creators:, titles:, publisher:, publication_year:, subjects: [], contributors: [], dates: [], language: nil, funding_references: [], resource_type: nil, alternate_identifiers: [], related_identifiers: [], sizes: [], formats: [], version: nil, rights_list: [], descriptions: [], geo_locations: []) # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists, Metrics/AbcSize
        self.identifier = identifier
        self.creators = creators
        self.titles = titles
        self.publisher = publisher
        self.publication_year = publication_year
        self.subjects = subjects
        self.funding_references = funding_references
        self.contributors = contributors
        self.dates = dates
        self.language = language
        self.resource_type = resource_type
        self.alternate_identifiers = alternate_identifiers
        self.related_identifiers = related_identifiers
        self.sizes = sizes
        self.formats = formats
        self.version = version
        self.rights_list = rights_list
        self.descriptions = descriptions
        self.geo_locations = geo_locations
      end

      # Sets the namespace prefix to be used when writing out XML (defaults to nil)
      # @param prefix [String, nil] The new prefix, or nil to use the default,
      #   unprefixed namespace
      def namespace_prefix=(prefix)
        old_namespace = namespace
        @namespace = ::XML::MappingExtensions::Namespace.new(uri: old_namespace.uri, schema_location: old_namespace.schema_location, prefix: prefix)
      end

      def identifier=(value)
        raise ArgumentError, 'Resource must have an identifier' unless value

        @identifier = value
      end

      def creators=(value)
        raise ArgumentError, 'Resource must have at least one creator' unless value && !value.empty?

        @creators = value
      end

      def titles=(value)
        raise ArgumentError, 'Resource must have at least one title' unless value && !value.empty?

        @titles = value
      end

      def publisher=(value)
        new_value = value&.strip
        raise ArgumentError, 'Resource must have a publisher' unless new_value && !new_value.empty?

        @publisher = new_value.strip
      end

      def publication_year=(value)
        raise ArgumentError, 'Resource must have a four-digit publication year' unless value&.to_i&.between?(1000, 9999)

        @publication_year = value.to_i
      end

      def subjects=(value)
        @subjects = (value&.select(&:value)) || []
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

      def sizes=(value)
        @sizes = value || []
      end

      def formats=(value)
        @formats = value || []
      end

      def version=(value)
        new_value = value&.to_s
        @version = new_value&.strip
      end

      def rights_list=(value)
        @rights_list = value || []
      end

      def descriptions=(value)
        @descriptions = (value&.select(&:value)) || []
      end

      def geo_locations=(value)
        @geo_locations = (value&.select(&:location?)) || []
      end

      # @!attribute [rw] identifier
      #   @return [Identifier] a persistent identifier that identifies a resource.
      identifier_node :identifier, 'identifier', class: Identifier

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
      empty_filtering_array_node :subjects, 'subjects', 'subject', class: Subject, default_value: []

      # @!attribute [rw] fundingReferences
      #   @return [Array<FundingReference>] information about financial support (funding) for the resource being registered.
      array_node :funding_references, 'fundingReferences', 'fundingReference', class: FundingReference, default_value: []

      # @!attribute [rw] contributors
      #   @return [Array<Contributor>] institutions or persons responsible for collecting, creating, or otherwise contributing to the developement of the dataset.
      array_node :contributors, 'contributors', 'contributor', class: Contributor, default_value: []

      # @!attribute [rw] dates
      #   @return [Array<Date>] different dates relevant to the work.
      array_node :dates, 'dates', 'date', class: Date, default_value: []

      # @!attribute [rw] language
      #   @return [String] Primary language of the resource: an IETF BCP 47, ISO 639-1 language code.
      text_node :language, 'language', default_value: nil

      # @!attribute [rw] resource_type
      #   @return [ResourceType, nil] the type of the resource. Optional.
      object_node :resource_type, 'resourceType', class: ResourceType, default_value: nil

      # @!attribute [rw] alternate_identifiers
      #   @return [Array<AlternateIdentifier>] an identifier or identifiers other than the primary {Identifier} applied to the resource being registered.
      array_node :alternate_identifiers, 'alternateIdentifiers', 'alternateIdentifier', class: AlternateIdentifier, default_value: []

      # @!attribute [rw] related_identifiers
      #   @return [Array<RelatedIdentifier>] identifiers of related resources.
      array_node :related_identifiers, 'relatedIdentifiers', 'relatedIdentifier', class: RelatedIdentifier, default_value: []

      # @!attribute [rw] sizes
      #   @return [Array<String>] unstructured size information about the resource.
      array_node :sizes, 'sizes', 'size', class: String, default_value: []

      # @!attribute [rw] formats
      #   @return [Array<String>] technical format of the resource, e.g. file extension or MIME type.
      array_node :formats, 'formats', 'format', class: String, default_value: []

      # @!attribute [rw] version
      #   @return [String] version number of the resource. Optional.
      text_node :version, 'version', default_value: nil

      # @!attribute [rw] rights_list
      #   @return [Array<Rights>] rights information for this resource.
      array_node :rights_list, 'rightsList', 'rights', class: Rights, default_value: []

      # @!attribute [rw] descriptions
      #   @return [Array<Description>] all additional information that does not fit in any of the other categories.
      empty_filtering_array_node :descriptions, 'descriptions', 'description', class: Description, default_value: []

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
        funder_contrib&.name
      end

      # Convenience method to get the funding contributor identifier.
      # @return [NameIdentifier, nil] the identifier of the funding contributor, if any.
      def funder_id
        funder_contrib&.identifier
      end

      # Convenience method to get the funding contributor identifier as a string.
      # @return [String, nil] the string value of the funding contributor's identifier, if any.
      def funder_id_value
        funder_id&.value
      end

      extend Gem::Deprecate
      deprecate(:funder_contrib, FundingReference, 2016, 9)
      deprecate(:funder_name, FundingReference, 2016, 9)
      deprecate(:funder_id, FundingReference, 2016, 9)
      deprecate(:funder_id_value, FundingReference, 2016, 9)

      use_mapping :datacite_3

      read_only_array_node :funding_references, 'fundingReferences', 'fundingReference', class: FundingReference, default_value: [], warn_reason: '<fundingReferences/> not supported in Datacite 3'

      fallback_mapping :datacite_3, :_default
    end

  end
end
