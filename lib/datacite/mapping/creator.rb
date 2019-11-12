# frozen_string_literal: true

require 'xml/mapping'
require 'datacite/mapping/read_only_nodes'
require 'datacite/mapping/name_identifier'
require 'datacite/mapping/creator_name'
require 'datacite/mapping/affiliation'

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
      # @param affiliations [Array<Affiliation>, nil] The creator's affiliations. Defaults to an empty list.
      def initialize(name:, given_name: nil, family_name: nil, identifier: nil, affiliations: [])
        self.name = name
        self.given_name = given_name
        self.family_name = family_name
        self.identifier = identifier
        self.affiliations = affiliations
      end

      # name can be entered as a string or a CreatorName object, but it will be stored
      # internally as a CreatorName object
      def name=(value)
        raise ArgumentError, 'Name cannot be empty or nil' unless value

        @creator_name = if value.is_a?(CreatorName)
                          value
                        else
                          CreatorName.new(value: value)
                        end
      end

      def creator_name=(value)
        raise ArgumentError, 'CreatorName cannot be empty or nil' unless value

        @creator_name = value
      end

      def name
        @creator_name&.value
      end

      def given_name=(value)
        new_value = value&.strip
        @given_name = new_value
      end

      def family_name=(value)
        new_value = value&.strip
        @family_name = new_value
      end

      # Affiliations can be entered as an array of Strings or an array of Affiliation objects,
      # but will be stored internally as an array of Affiliation objects
      def affiliations=(value)
        @affiliations = []
        value&.each do |affil|
          @affiliations << if affil.is_a?(Affiliation)
                             affil
                           else
                             Affiliation.new(value: affil)
                           end
        end
      end

      def affiliation_names
        @affiliations.map { |affil| affil&.value }
      end

      # @!attribute [rw] name
      #   @return [String] The personal name of the creator, in the format `Family, Given`. Cannot be empty or nil.
      object_node :creator_name, 'creatorName', class: CreatorName

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
      array_node :affiliations, 'affiliation', class: Affiliation, default_value: []

      use_mapping :datacite_3

      read_only_text_node :given_name, 'givenName', default_value: nil, warn_reason: '<givenName/> not supported in Datacite 3'
      read_only_text_node :family_name, 'familyName', default_value: nil, warn_reason: '<familyName/> not supported in Datacite 3'

      fallback_mapping :datacite_3, :_default
    end
  end
end
