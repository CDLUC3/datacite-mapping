require 'xml/mapping'

module Datacite
  module Mapping

    # Subject, keyword, classification code, or key phrase describing the {Resource}.
    class Subject
      include XML::Mapping

      # @!attribute [rw] scheme
      #   @return [String, nil] the subject scheme or classification code or authority if one is used. Optional.
      text_node :scheme, '@subjectScheme', default_value: nil

      # @!attribute [rw] scheme_uri
      #   @return [URI, nil] the URI of the subject scheme or classification code or authority if one is used. Optional.
      uri_node :scheme_uri, '@schemeURI', default_value: nil

      # @!attribute [rw] scheme
      #   @return [String, nil] the subject scheme or classification code or authority if one is used. Optional.
      text_node :language, '@xml:lang', default_value: nil
      text_node :value, 'text()'

      alias_method :_language, :language
      private :_language

      alias_method :_language=, :language=
      private :_language=

      def initialize(scheme: nil, scheme_uri: nil, language:, value:)
        self.scheme = scheme
        self.scheme_uri = scheme_uri
        self.language = language
        self.value = value
      end

      def language
        _language || 'en'
      end

      def language=(value)
        self._language = value.strip if value
      end
    end
  end
end
