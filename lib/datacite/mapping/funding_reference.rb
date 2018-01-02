# frozen_string_literal: true

require 'xml/mapping_extensions'

module Datacite
  module Mapping

    class FunderIdentifierType < TypesafeEnum::Base
      # @!parse ISNI = ISNI
      new :ISNI, 'ISNI'

      # @!parse GRID = GRID
      new :GRID, 'GRID'

      # @!parse CROSSREF_FUNDER = 'Crossref Funder ID'
      new :CROSSREF_FUNDER_ID, 'Crossref Funder ID'

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
        raise ArgumentError, 'Value cannot be empty or nil' unless value && !value.empty?
        @value = value
      end

      def type=(value)
        raise ArgumentError, 'Type cannot be nil' unless value
        @type = value
      end

      def to_s
        "#{type.value}: #{value}"
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
        raise ArgumentError, 'Value cannot be empty or nil' unless value && !value.empty?
        @value = value
      end

      def to_s
        "#{value} (#{uri})"
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
        @award_number = award_number_or_nil(value)
      end

      def to_s
        fields = %i[name identifier award_number award_title].map { |f| "#{f}: #{send(f)}" }
        "FundingReference { #{fields.join(', ')} }"
      end

      text_node :name, 'funderName'
      object_node :identifier, 'funderIdentifier', class: FunderIdentifier, default_value: nil
      object_node :award_number, 'awardNumber', class: AwardNumber, default_value: nil
      text_node :award_title, 'awardTitle', default_value: nil

      fallback_mapping :datacite_3, :_default

      private

      def award_number_or_nil(value)
        return nil unless value
        return value if value.is_a?(AwardNumber)
        new_value = value.to_s.strip
        return nil if new_value.empty?
        AwardNumber.new(value: new_value)
      end
    end
  end
end
