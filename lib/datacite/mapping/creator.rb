require 'xml/mapping'
require 'datacite/mapping/name_identifier'

module Datacite
  module Mapping
    # The main researchers involved working on the data, or the authors of the publication in priority order.
    class Creator
      include XML::Mapping

      # Initializes a new {Creator}.
      # @param name [String] The personal name of the creator, in the format `Family, Given`. Cannot be empty or nil.
      # @param given_name [String, nil] The given name of the creator. Optional.
      # @param given_name [String, nil] The family name of the creator. Optional.
      # @param identifier [NameIdentifier, nil] An identifier for the creator. Optional.
      # @param affiliations [Array<String>, nil] The creator's affiliations. Defaults to an empty list.
      def initialize(name:, given_name: nil, family_name: nil, identifier: nil, affiliations: [])
        self.name = name
        self.given_name = given_name
        self.family_name = family_name
        self.identifier = identifier
        self.affiliations = affiliations
      end

      def name=(value)
        new_value = value && value.strip
        fail ArgumentError, 'Name cannot be empty or nil' unless new_value && !new_value.empty?
        @name = new_value
      end

      def given_name=(value)
        new_value = value && value.strip
        @given_name = new_value
      end

      def family_name=(value)
        new_value = value && value.strip
        @family_name = new_value
      end

      def affiliations=(value)
        @affiliations = value || []
      end

      # @!attribute [rw] name
      #   @return [String] The personal name of the creator, in the format `Family, Given`. Cannot be empty or nil.
      text_node :name, 'creatorName'

      # @!attribute [rw] given_name
      #   @return [String, nil] The given name of the creator. Optional.
      text_node :given_name, 'givenName', default_value: nil

      # @!attribute [rw] family_name
      #   @return [String, nil] The family name of the creator. Optional.
      text_node :family_name, 'familyName', default_value: nil

      # @!attribute [rw] identifier
      #   @return [NameIdentifier, nil] An identifier for the creator. Optional.
      object_node :identifier, 'nameIdentifier', class: NameIdentifier, default_value: nil

      # @!attribute [rw] affiliations
      #   @return [Array<String>, nil] The creator's affiliations. Defaults to an empty list.
      array_node :affiliations, 'affiliation', class: String, default_value: []

    end
  end
end
