require 'xml/mapping'
require_relative 'identifier'
require_relative 'creator'
require_relative 'title'
require_relative 'subject'
require_relative 'resource_type'
require_relative 'alternate_identifier'

module Datacite
  module Mapping
    class Resource
      include XML::Mapping

      object_node :identifier, 'identifier', class: Identifier
      array_node :creator, 'creators', 'creator', class: Creator
      array_node :title, 'titles', 'title', class: Title
      text_node :publisher, 'publisher'
      numeric_node :publication_year, 'publicationYear'
      array_node :subject, 'subjects', 'subject', class: Subject
      text_node :_lang, 'language'
      object_node :resource_type, 'resourceType', class: ResourceType
      array_node :alternate_identifier, 'alternateIdentifiers', 'alternateIdentifier', class: AlternateIdentifier

      def language
        _lang || 'en'
      end

      def language=(value)
        fail ArgumentError, 'Language cannot be nil' unless value
        self._lang = value
      end
    end
  end
end
