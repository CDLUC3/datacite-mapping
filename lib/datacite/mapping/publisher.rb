# frozen_string_literal: true

require 'xml/mapping_extensions'

module Datacite
  module Mapping

    # The type of the resource
    class Publisher
      include XML::Mapping

      # Initializes a new {Publisher}
      # @param language [String, nil] an IETF BCP 47, ISO 639-1 language code identifying the language.
      # @param value [String] name of the publisher
      def initialize(language: nil, value:)
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

      # @!attribute [rw] language
      #   @return [String] an IETF BCP 47, ISO 639-1 language code identifying the language.
      text_node :language, '@xml:lang', default_value: nil

      # @!attribute [rw] value
      #   @return [String] the title itself.
      text_node :value, 'text()'

      fallback_mapping :datacite_3, :_default
    end
  end
end
