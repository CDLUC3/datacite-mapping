require 'xml/mapping'

module Datacite
  module Mapping

    # Subject, keyword, classification code, or key phrase describing the {Resource}.
    class Subject
      include XML::Mapping

      # Initializes a new {Subject}
      # @param scheme [String, nil] the subject scheme or classification code or authority if one is used. Optional.
      # @param scheme_uri [URI, nil] the URI of the subject scheme or classification code or authority if one is used. Optional.
      # @param language [String] an IETF BCP 47, ISO 639-1 language code identifying the language.
      #   It's unclear from the spec whether language is required; to play it safe, if it's missing, we default to 'en'.
      # @param value [String] the subject itself.
      def initialize(scheme: nil, scheme_uri: nil, language: 'en', value:)
        self.scheme = scheme
        self.scheme_uri = scheme_uri
        self.language = language
        self.value = value
      end

      def language
        @language || 'en'
      end

      def language=(value)
        @language = value.strip if value
      end

      def value=(v)
        new_value = v && v.strip
        fail ArgumentError, 'Value cannot be empty or nil' unless new_value && !new_value.empty?
        @value = new_value.strip
      end

      # @!attribute [rw] scheme
      #   @return [String, nil] the subject scheme or classification code or authority if one is used. Optional.
      text_node :scheme, '@subjectScheme', default_value: nil

      # @!attribute [rw] scheme_uri
      #   @return [URI, nil] the URI of the subject scheme or classification code or authority if one is used. Optional.
      uri_node :scheme_uri, '@schemeURI', default_value: nil

      # @!attribute [rw] language
      #   @return [String] an IETF BCP 47, ISO 639-1 language code identifying the language.
      #     It's unclear from the spec whether language is required; to play it safe, if it's missing, we default to 'en'.
      text_node :language, '@xml:lang', default_value: nil

      # @!attribute [rw] value
      #   @return [String] the subject itself.
      text_node :value, 'text()'

    end
  end
end
