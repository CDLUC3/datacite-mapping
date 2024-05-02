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
      def initialize(value:, language: nil)
        self.language = language
        self.identifier = identifier
        self.scheme = scheme
        self.scheme_uri = scheme_uri
        self.value = value
      end

      def language=(value)
        @language = value&.strip
      end

      def scheme=(new_value)
        raise ArgumentError, 'Scheme cannot be empty or nil' unless new_value && !new_value.empty?

        @scheme = new_value
      end

      def value=(value)
        new_value = value&.strip
        raise ArgumentError, 'Value cannot be empty or nil' unless new_value && !new_value.empty?

        @value = new_value.strip
      end

      # @!attribute [rw] language
      #   @return [String] an IETF BCP 47, ISO 639-1 language code identifying the language.
      text_node :language, '@xml:lang', default_value: nil

      # @!attribute [rw] identifier
      #   @return [NameIdentifier, nil] an identifier for the contributor. Optional.
      object_node :identifier, '@publisherIdentifier', default_value: nil

      # @!attribute [rw] scheme
      #   @return [String] the name identifier scheme. Cannot be nil.
      text_node :scheme, '@publisherIdentifierScheme'

      # @!attribute [rw] scheme_uri
      #   @return [URI, nil] the URI of the identifier scheme. Optional.
      uri_node :scheme_uri, '@schemeURI', default_value: nil

      # @!attribute [rw] value
      #   @return [String] the title itself.
      text_node :value, 'text()'

      fallback_mapping :datacite_3, :_default
    end
  end
end
