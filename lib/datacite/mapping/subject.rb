require 'xml/mapping'

module Datacite
  module Mapping
    class Subject
      include XML::Mapping

      text_node :scheme, '@subjectScheme', default_value: nil
      uri_node :scheme_uri, '@schemeURI', default_value: nil
      text_node :_lang, '@xml:lang', default_value: nil
      text_node :value, 'text()'

      def initialize(scheme: nil, scheme_uri: nil, language:, value:)
        self.scheme = scheme
        self.scheme_uri = scheme_uri
        self.language = language
        self.value = value
      end

      def language
        _lang || 'en'
      end

      def language=(value)
        fail ArgumentError, 'Language cannot be nil' unless value
        self._lang = value
      end
    end
  end
end
