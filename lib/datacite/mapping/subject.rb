# frozen_string_literal: true

require 'xml/mapping'

module Datacite
  module Mapping

    # Subject, keyword, classification code, or key phrase describing the {Resource}.
    class Subject
      include XML::Mapping

      # Initializes a new {Subject}
      # @param scheme [String, nil] the subject scheme or classification code or authority if one is used. Optional.
      # @param scheme_uri [URI, nil] the URI of the subject scheme or classification code or authority if one is used. Optional.
      # @param language [String, nil] an IETF BCP 47, ISO 639-1 language code identifying the language.
      # @param value [String] the subject itself.
      def initialize(value:, scheme: nil, scheme_uri: nil, language: nil)
        self.scheme = scheme
        self.scheme_uri = scheme_uri
        self.language = language
        self.value = value
      end

      def language=(value)
        @language = value&.strip
      end

      def value=(value)
        new_value = value&.strip
        raise ArgumentError, 'Value cannot be empty or nil' unless new_value && !new_value.empty?

        @value = new_value
      end

      # @!attribute [rw] scheme
      #   @return [String, nil] the subject scheme or classification code or authority if one is used. Optional.
      text_node :scheme, '@subjectScheme', default_value: nil

      # @!attribute [rw] scheme_uri
      #   @return [URI, nil] the URI of the subject scheme or classification code or authority if one is used. Optional.
      uri_node :scheme_uri, '@schemeURI', default_value: nil

      # @!attribute [rw] language
      #   @return [String, nil] an IETF BCP 47, ISO 639-1 language code identifying the language.
      text_node :language, '@xml:lang', default_value: nil

      # @!attribute [rw] value
      #   @return [String] the subject itself.
      text_node :value, 'text()'

      fallback_mapping :datacite_3, :_default
    end
  end
end
