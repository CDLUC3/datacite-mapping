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
        _lang || 'en-us'
      end

      def lang=(value)
        raise ArgumentError, 'Language cannot be nil' unless value
        _lang = value
      end

    end

    class Subjects
      include XML::Mapping

      array_node :subjects, 'subject', class: Subject

      def initialize(subjects:)
        self.subjects = subjects
      end

    end
  end
end
