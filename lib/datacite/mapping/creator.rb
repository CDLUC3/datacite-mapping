require 'xml/mapping'
require_relative 'name_identifier'

module Datacite
  module Mapping
    class Creator
      include ::XML::Mapping

      text_node :name, 'creatorName'
      object_node :identifier, 'nameIdentifier', class: NameIdentifier
      array_node :affiliations, 'affiliation', class: String

      def initialize(name:, identifier: nil, affiliations: nil)
        self.name = name
        self.identifier = identifier
        self.affiliations = affiliations || []
      end
    end

    # Not to be instantiated directly -- just call `Resource#creators`
    class Creators
      include ::XML::Mapping
      array_node :creators, 'creator', class: Creator

      def initialize(creators:)
        self.creators = creators
      end
    end
  end
end
