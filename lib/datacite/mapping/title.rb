require 'xml/mapping'
require_relative 'types/title_type'

module Datacite
  module Mapping
    class Title
      include ::XML::Mapping

      text_node :lang, '@xml:lang', default_value: nil
      title_type_node :type, '@titleType', default_value: nil
      text_node :value, 'text()'

      def initialize(lang: nil, type: nil, value:)
        self.lang = lang
        self.type = type
        self.value = value
      end
    end

    # Not to be instantiated directly -- just call `Resource#titles`
    class Titles
      include ::XML::Mapping
      array_node :titles, 'title', class: Title

      def initialize(titles:)
        self.titles = titles
      end
    end
  end
end
