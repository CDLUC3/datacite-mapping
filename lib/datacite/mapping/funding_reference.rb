require 'xml/mapping_extensions'

module Datacite
  module Mapping

    class FunderIdentifierType < TypesafeEnum::Base
      # @!parse ISNI = ISNI
      new :ISNI, 'ISNI'

      # @!parse GRID = GRID
      new :GRID, 'GRID'

      # @!parse CROSSREF_FUNDER = 'CrossRef Funder'
      new :CROSSREF_FUNDER, 'CrossRef Funder'

      # @!parse OTHER = Other
      new :OTHER, 'Other'
    end

    class FunderIdentifier
      include XML::Mapping

      # @param type [FunderIdentifierType] the identifier type. Cannot be nil.
      # @param value [String] the identifier value. Cannot be nil.
      def initialize(type:, value:)
        self.type = type
        self.value = value
      end

      def value=(value)
        fail ArgumentError, 'Value cannot be empty or nil' unless value && !value.empty?
        @value = value
      end

      def type=(value)
        fail ArgumentError, 'Type cannot be nil' unless value
        @type = value
      end

      # @!attribute [rw] type
      #   @return [FunderIdentifierType] the identifier type. Cannot be nil.
      typesafe_enum_node :type, '@funderIdentifierType', class: FunderIdentifierType

      # @!attribute [rw] value
      #   @return [String] the identifier value. Cannot be nil.
      text_node :value, 'text()'
    end

    class AwardNumber
      include XML::Mapping

      def initialize(uri: nil, value:)
        self.uri = uri
        self.value = value
      end

      def value=(value)
        fail ArgumentError, 'Value cannot be empty or nil' unless value && !value.empty?
        @value = value
      end

      # @!attribute [rw] uri
      #  @return [URI, nil] The URI leading to a page provided by the funder for more information about the award
      uri_node :uri, '@awardURI', default_value: nil

      # @!attribute [rw] value
      #   @return [String] the award number. Cannot be nil.
      text_node :value, 'text()'
    end

    class FundingReference
      include XML::Mapping

      root_element_name 'fundingReference'

      def initialize(name:, identifier: nil, award_number: nil, award_title: nil)
        self.name = name
        self.identifier = identifier
        self.award_number = award_number
        self.award_title = award_title
      end

      def award_number=(value)
        if value.nil? || value.is_a?(AwardNumber)
          @award_number = value
        else
          @award_number = AwardNumber.new(value: value.to_s)
        end
      end

      text_node :name, 'funderName'
      object_node :identifier, 'funderIdentifier', class: FunderIdentifier, default_value: nil
      object_node :award_number, 'awardNumber', class: AwardNumber, default_value: nil
      text_node :award_title, 'awardTitle', default_value: nil
    end
  end
end
