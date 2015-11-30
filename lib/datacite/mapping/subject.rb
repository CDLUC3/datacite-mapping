require 'xml/mapping'

module Datacite
  module Mapping
    class Subject
      include XML::Mapping

      text_node :scheme, '@subjectScheme', default_value: nil
      uri_node :scheme_uri, '@schemeURI', default_value: nil
      text_node :_lang, '@xml:lang', default_value: nil
      text_node :value, 'text()'

      def initialize(scheme: nil, scheme_uri: nil, lang:, value:)
        self.scheme = scheme
        self.scheme_uri = scheme_uri
        self._lang = lang
        self.value = value
      end

      def lang
        _lang || 'en'
      end

      def lang=(value)
        fail ArgumentError, 'Language cannot be nil' unless value
        self._lang = value
      end
    end
  end
end
