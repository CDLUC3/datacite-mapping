require 'xml/mapping'

module XML
  class XXPath
    attr_reader :xpathstr
  end
end

module Datacite
  module Mapping
    class ReadOnlyTextNode < XML::Mapping::TextNode
      attr_reader :warn_reason

      def initialize(*args)
        super
        @warn_reason = @options[:warn_reason]
      end

      def obj_to_xml(_obj, _xml)
        warning = "Ignoring #{@attrname}; #{@path.xpathstr} not written"
        warning << "; #{warn_reason}" if warn_reason
        Mapping.warn(warning)
      end
    end
    XML::Mapping.add_node_class ReadOnlyTextNode
  end
end
