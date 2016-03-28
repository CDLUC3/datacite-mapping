require 'xml/mapping'
require_relative 'name_identifier'

module Datacite
  module Mapping
    # The main researchers involved working on the data, or the authors of the publication in priority order.
    class Creator
      include XML::Mapping

      # Initializes a new {Creator}.
      # @param name [String] The personal name of the creator, in the format `Family, Given`. Cannot be empty or nil.
      # @param identifier [NameIdentifier, nil] An identifier for the creator. Optional.
      # @param affiliations [Array<String>, nil] The creator's affiliations. Defaults to an empty list.
      def initialize(name:, identifier: nil, affiliations: [])
        self.name = name
        self.identifier = identifier
        self.affiliations = affiliations
      end

      def name=(value)
        fail ArgumentError, 'Name cannot be empty or nil' unless value && !value.empty?
        @name = value
      end

      def affiliations=(value)
        @affiliations = value || []
      end

      # @!attribute [rw] name
      #   @return [String] The personal name of the creator, in the format `Family, Given`. Cannot be empty or nil.
      text_node :name, 'creatorName'

      # @!attribute [rw] identifier
      #   @return [NameIdentifier, nil] An identifier for the creator. Optional.
      object_node :identifier, 'nameIdentifier', class: NameIdentifier, default_value: nil

      # @!attribute [rw] affiliations
      #   @return [Array<String>, nil] The creator's affiliations. Defaults to an empty list.
      array_node :affiliations, 'affiliation', class: String, default_value: []

    end
  end
end
