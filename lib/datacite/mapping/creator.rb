require 'xml/mapping'
require_relative 'name_identifier'

module Datacite
  module Mapping
    # The main researchers involved working on the data, or the authors of the publication in priority order.
    class Creator
      include XML::Mapping

      # @!attribute [rw] name
      #   @return [String] The personal name of the creator, in the format `Family, Given`. Cannot be empty or nil.
      text_node :name, 'creatorName'

      # @!attribute [rw] identifier
      #   @return [NameIdentifier, nil] An identifier for the creator. Optional.
      object_node :identifier, 'nameIdentifier', class: NameIdentifier

      # @!attribute [rw] affiliations
      #   @return [Array<Affiliation>, nil] The creator's affiliations. Defaults to an empty list.
      array_node :affiliations, 'affiliation', class: String, default_value: []

      alias_method :_name=, :name=
      private :_name=

      alias_method :_affiliations=, :affiliations=
      private :_affiliations=

      # Initializes a new {Creator}.
      # @param name [String] The personal name of the creator, in the format `Family, Given`. Cannot be empty or nil.
      # @param identifier [NameIdentifier, nil] An identifier for the creator. Optional.
      # @param affiliations [Array<Affiliation>, nil] The creator's affiliations. Defaults to an empty list.
      def initialize(name:, identifier: nil, affiliations: [])
        self.name = name
        self.identifier = identifier
        self.affiliations = affiliations
      end

      def name=(value)
        fail ArgumentError, 'Name cannot be empty or nil' unless value && !value.empty?
        self._name = value
      end

      def affiliations=(value)
        self._affiliations = value || []
      end
    end
  end
end
