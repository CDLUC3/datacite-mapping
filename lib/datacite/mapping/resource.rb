require 'xml/mapping_extensions'
require 'datacite/mapping/alternate_identifier'
require 'datacite/mapping/creator'
require 'datacite/mapping/identifier'
require 'datacite/mapping/nonvalidating'
require 'datacite/mapping/related_identifier'
require 'datacite/mapping/resource_type'
require 'datacite/mapping/rights'
require 'datacite/mapping/subject'
require 'datacite/mapping/title'

module Datacite
  module Mapping

    # A collection of metadata properties chosen for the accurate and consistent identification
    # of a resource for citation and retrieval purposes, along with recommended use instructions.
    # The resource that is being identified can be of any kind, but it is typically a dataset.
    class Resource
      include XML::MappingExtensions::Namespaced

      namespace XML::MappingExtensions::Namespace.new(
        uri: 'http://datacite.org/schema/kernel-3',
        schema_location: 'http://schema.datacite.org/meta/kernel-3/metadata.xsd'
      )

      # Initialies a new {Resource}
      #
      # @param identifier [Identifier] a persistent identifier that identifies a resource.
      # @param creators [Array<Creator>] the main researchers involved working on the data, or the authors of the publication in priority order.
      # @param titles [Array<Title>] the names or titles by which a resource is known.
      # @param publisher [String] the name of the entity that holds, archives, publishes prints, distributes, releases, issues, or produces the resource.
      # @param publication_year [Integer] year when the resource is made publicly available.
      # @param subjects [Array<Subject>] subjects, keywords, classification codes, or key phrases describing the resource.
      # @param contributors [Array<Contributor>] institutions or persons responsible for collecting, creating, or otherwise contributing to the developement of the dataset.
      # @param dates [Array<Date>] different dates relevant to the work.
      # @param language [String] Primary language of the resource: an IETF BCP 47, ISO 639-1 language code.
      #   It's unclear from the spec whether language is required; to play it safe, if it's missing, we default to 'en'.
      # @param resource_type [ResourceType, nil] the type of the resource
      # @param alternate_identifiers [Array<AlternateIdentifier>] an identifier or identifiers other than the primary {Identifier} applied to the resource being registered.
      # @param related_identifiers [Array<RelatedIdentifier>] identifiers of related resources.
      # @param sizes [Array<String>] unstructured size information about the resource.
      # @param formats [Array<String>] technical format of the resource, e.g. file extension or MIME type.
      # @param version [String] version number of the resource.
      # @param rights_list [Array<Rights>] rights information for this resource.
      # @param descriptions [Array<Description>] all additional information that does not fit in any of the other categories.
      # @param geo_locations [Array<GeoLocations>] spatial region or named place where the data was gathered or about which the data is focused.
      def initialize(identifier:, creators:, titles:, publisher:, publication_year:, subjects: [], contributors: [], dates: [], language: 'en', resource_type: nil, alternate_identifiers: [], related_identifiers: [], sizes: [], formats: [], version: nil, rights_list: [], descriptions: [], geo_locations: []) # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists, Metrics/AbcSize
        self.identifier = identifier
        self.creators = creators
        self.titles = titles
        self.publisher = publisher
        self.publication_year = publication_year
        self.subjects = subjects
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
      def self.namespace_prefix=(prefix)
        old_namespace = namespace
        namespace ::XML::MappingExtensions::Namespace.new(uri: old_namespace.uri, schema_location: old_namespace.schema_location, prefix: prefix)
      end

      def language
        @language || 'en'
      end

      def language=(value)
        @language = value.strip if value
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
        fail ArgumentError, 'Resource must have at least one publisher' unless value && value.size > 0
        @publisher = value.strip
      end

      def publication_year=(value)
        fail ArgumentError, 'Resource must have a four-digit publication year' unless value && value.to_i.between?(1000, 9999)
        @publication_year = value.to_i
      end

      def subject
        (@subjects ||= []).select(&:value)
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

      # @!attribute [rw] contributors
      #   @return [Array<Contributor>] institutions or persons responsible for collecting, creating, or otherwise contributing to the developement of the dataset.
      array_node :contributors, 'contributors', 'contributor', class: Contributor, default_value: []

      # @!attribute [rw] dates
      #   @return [Array<Date>] different dates relevant to the work.
      array_node :dates, 'dates', 'date', class: Date, default_value: []

      # @!attribute [rw] language
      #   @return [String] Primary language of the resource: an IETF BCP 47, ISO 639-1 language code.
      #   It's unclear from the spec whether language is required; to play it safe, if it's missing, we default to 'en'.
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
        @funder_contrib ||= contributors.find { |c| c.type == ContributorType::FUNDER }
      end

      # Convenience method to get the name of the funding contributor.
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

      use_mapping :nonvalidating

      # Ignore missing or invalid values
      object_node :identifier, 'identifier', class: Nonvalidating::Identifier
      array_node :subjects, 'subjects', 'subject', class: Nonvalidating::Subject, default_value: []
      text_node :language, 'language', default_value: nil

      # TODO: Handle nested contributors, date ranges (e.g. spec/data/dash1-datacite-xml/ucsf-ark+=b7272=q6bg2kwf-mrt-datacite.xml)

      fallback_mapping :nonvalidating, :_default
    end
  end
end
