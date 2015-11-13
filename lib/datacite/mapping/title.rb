require 'xml/mapping'
require_relative 'types/title_type'

module Datacite
  module Mapping
    class Title
      include XML::Mapping

      text_node :_lang, '@xml:lang', default_value: nil
      title_type_node :type, '@titleType', default_value: nil
      text_node :value, 'text()'

      def initialize(lang:, type: nil, value:)
        self._lang = lang
        self.type = type
        self.value = value
      end

      def lang
        _lang || 'en'
      end

      def lang=(value)
        raise ArgumentError, 'Language cannot be nil' unless value
        self._lang = value
      end

    end

    # Not to be instantiated directly -- just call `Resource#titles`
    class Titles
      include XML::Mapping

      array_node :titles, 'title', class: Title

      def initialize(titles:)
        self.titles = titles
      end
    end
  end
end
