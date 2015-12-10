require 'xml/mapping'
require_relative 'identifier'
require_relative 'creator'
require_relative 'title'
require_relative 'subject'
require_relative 'resource_type'
require_relative 'alternate_identifier'
require_relative 'related_identifier'
require_relative 'rights'

module Datacite
  module Mapping

    # A collection of metadata properties chosen for the accurate and consistent identification
    # of a resource for citation and retrieval purposes, along with recommended use instructions.
    # The resource that is being identified can be of any kind, but it is typically a dataset.
    class Resource
      include XML::Mapping

      # @!attribute [rw] identifier
      #   @return [Identifier] a persistent identifier that identifies a resource.
      object_node :identifier, 'identifier', class: Identifier

      # @!attribute [rw] creators
      #   @return [Array<Creator>] the main researchers involved working on the data, or the authors of the publication in priority order.
      array_node :creators, 'creators', 'creator', class: Creator, default_value: []

      # @!attribute [rw] titles
      #   @return [Array<Title>] the names or titles by which a resource is known.
      array_node :titles, 'titles', 'title', class: Title, default_value: []

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
      text_node :language, 'language'

      # @!attribute [rw] resource_type
      #   @return [ResourceType, nil] the type of the resource
      object_node :resource_type, 'resourceType', class: ResourceType

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
      #   @return [String] version number of the resource.
      text_node :version, 'version'

      # @!attribute [rw] rights_list
      #   @return [Array<Rights>] rights information for this resource.
      array_node :rights_list, 'rightsList', 'rights', class: Rights, default_value: []

      # @!attribute [rw] descriptions
      #   @return [Array<Description>] all additional information that does not fit in any of the other categories.
      array_node :descriptions, 'descriptions', 'description', class: Description, default_value: []

      # @!attribute [rw] geo_locations
      #   @return [Array<GeoLocations>] spatial region or named place where the data was gathered or about which the data is focused.
      array_node :geo_locations, 'geoLocations', 'geoLocation', class: GeoLocation, default_value: []

      alias_method :_language, :language
      private :_language

      alias_method :_language=, :language=
      private :_language=

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

      def language
        _language || 'en'
      end

      def language=(value)
        self._language = value.strip if value
      end

      # Overrides +::XML::Mapping.pre_save+ to write namespace information.
      # Used for writing.
      def pre_save(options = { mapping: :_default })
        xml = super(options)
        xml.add_namespace('http://datacite.org/schema/kernel-3')
        xml.add_namespace('xsi', 'http://www.w3.org/2001/XMLSchema-instance')
        xml.add_attribute('xsi:schemaLocation', 'http://datacite.org/schema/kernel-3 http://schema.datacite.org/meta/kernel-3/metadata.xsd')
        xml
      end

    end
  end
end
