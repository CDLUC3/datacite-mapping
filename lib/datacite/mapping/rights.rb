require 'xml/mapping_extensions'

module Datacite
  module Mapping
    class Rights
      include XML::Mapping

      uri_node :uri, '@rightsURI', default_value: null
      text_node :value, 'text()'

      def initialize(uri: null, value:)
        self.uri = uri
        self.value = value
      end
    end
  end
end
