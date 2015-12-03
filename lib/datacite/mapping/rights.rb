require 'xml/mapping_extensions'

module Datacite
  module Mapping
    class Rights
      include XML::Mapping

      uri_node :uri, '@rightsURI', default_value: nil
      text_node :value, 'text()'

      def initialize(uri: nil, value:)
        self.uri = uri
        self.value = value
      end

      alias_method :_value=, :value=

      def value=(v)
        fail ArgumentError, 'Value cannot be empty or nil' unless v && !v.empty?
        self._value = v.strip
      end
    end
  end
end
