require 'xml/mapping_extensions'

# TODO: port this to xml-mapping_extensions
module XML
  module MappingExtensions
    class Namespace
      def with_prefix(new_prefix)
        Namespace.new(uri: uri, prefix: new_prefix, schema_location: schema_location)
      end
    end
  end
end
