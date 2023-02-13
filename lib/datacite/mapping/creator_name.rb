# frozen_string_literal: true

require 'xml/mapping'
require 'datacite/mapping/read_only_nodes'
require 'datacite/mapping/name_identifier'
require 'datacite/mapping/name_type'

module Datacite
  module Mapping
    class CreatorName
      include XML::Mapping
      def initialize(value:, type: nil, language: nil)
        self.type = type
        self.language = language
        self.value = value
      end

      def language=(value)
        @language = value&.strip
      end

      def value=(value)
        new_value = value&.strip
        raise ArgumentError, 'Value cannot be empty or nil' unless new_value && !new_value.empty?

        @value = new_value.strip
      end

      # @!attribute [rw] type
      #   @return [NameType, nil] the name type. Optional.
      typesafe_enum_node :type, '@nameType', class: NameType, default_value: nil

      # @!attribute [rw] language
      #   @return [String] an IETF BCP 47, ISO 639-1 language code identifying the language.
      text_node :language, '@xml:lang', default_value: nil

      # @!attribute [rw] value
      #   @return [String] the name itself.
      text_node :value, 'text()'
    end
  end
end
