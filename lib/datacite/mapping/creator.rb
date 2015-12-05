require 'xml/mapping'
require_relative 'name_identifier'

module Datacite
  module Mapping
    # The main researchers involved working on the data, or the authors of the publication in priority order.
    class Creator
      include XML::Mapping

      text_node :name, 'creatorName'
      object_node :identifier, 'nameIdentifier', class: NameIdentifier
      array_node :affiliations, 'affiliation', class: String

      # Initializes a new {Creator}.
      # @param name [String] The personal name of the creator, in the format `Family, Given`. Cannot be empty or nil
      # @param identifier [NameIdentifier] An identifier for the creator. Optional.
      # @param affiliations [Array<Affiliation>] The creator's affiliations. Defaults to an empty list.
      def initialize(name:, identifier: nil, affiliations: nil)
        self.name = name
        self.identifier = identifier
        self.affiliations = affiliations || []
      end
    end
  end
end
