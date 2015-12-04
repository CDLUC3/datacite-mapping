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
    class Resource
      include XML::Mapping

      object_node :identifier, 'identifier', class: Identifier
      array_node :creators, 'creators', 'creator', class: Creator
      array_node :titles, 'titles', 'title', class: Title
      text_node :publisher, 'publisher'
      numeric_node :publication_year, 'publicationYear'
      array_node :subjects, 'subjects', 'subject', class: Subject
      array_node :dates, 'dates', 'date', class: Date
      text_node :language, 'language'
      object_node :resource_type, 'resourceType', class: ResourceType
      array_node :alternate_identifiers, 'alternateIdentifiers', 'alternateIdentifier', class: AlternateIdentifier
      array_node :related_identifiers, 'relatedIdentifiers', 'relatedIdentifier', class: RelatedIdentifier
      array_node :sizes, 'sizes', 'size', class: String
      array_node :formats, 'formats', 'format', class: String
      text_node :version, 'version'
      array_node :rights_list, 'rightsList', 'rights', class: Rights

      def initialize(identifier:, creators:, titles:, publisher:, publication_year:, subjects: [], dates: [], language: [], resource_type: nil, alternate_identifiers: [], related_identifiers: [], sizes: [], formats: [], version: nil, rights_list: []) # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists
        self.identifier = identifier
        self.creators = creators
        self.titles = titles
        self.publisher = publisher
        self.publication_year = publication_year
        self.subjects = subjects
        self.dates = dates
        self.language = language
        self.resource_type = resource_type
        self.alternate_identifiers = alternate_identifiers
        self.related_identifiers = related_identifiers
        self.sizes = sizes
        self.formats = formats
        self.version = version
        self.rights_list = rights_list
      end

    end
  end
end
