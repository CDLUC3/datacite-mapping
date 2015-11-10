require 'xml/mapping'
require_relative 'types/title_type'

module Datacite
  module Mapping
    class Title
      include ::XML::Mapping

      text_node :lang, '@xml:lang', default: nil
      title_type_node :type, '@titleType', default: nil
      text_node :value, 'text()'

      def initialize(lang: nil, type: nil, value:)
        self.lang = lang
        self.type = type
        self.value = value
      end
    end
  end
end
