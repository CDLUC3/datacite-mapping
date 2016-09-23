require 'xml/mapping'

module XML
  class XXPath
    attr_reader :xpathstr
  end
end

module Datacite
  module Mapping

    module ReadOnlyNodes
      def warn_reason
        @warn_reason ||= @options[:warn_reason]
      end

      def xpathstr
        @xpathstr ||= begin
          path = @path || @base_path
          path_str = path && path.xpathstr
          path_str.match(/[()@]/) ? path_str : "<#{path_str}>"
        end
      end

      def value_str(obj)
        val = obj.send(@attrname)
        return val.to_s if val.is_a?(Array)
        "'#{val}'"
      end

      def obj_to_xml(obj, _xml)
        warning = "Ignoring #{@attrname} value #{value_str(obj)}; #{xpathstr} not written"
        warning << " (#{warn_reason})" if warn_reason
        ReadOnlyNodes.warn(warning)
      end

      # public to allow testing
      def self.warn(warning)
        super
      end
    end

    class ReadOnlyTextNode < XML::Mapping::TextNode
      include ReadOnlyNodes
    end
    XML::Mapping.add_node_class ReadOnlyTextNode

    class ReadOnlyArrayNode < XML::Mapping::ArrayNode
      include ReadOnlyNodes
    end
    XML::Mapping.add_node_class ReadOnlyArrayNode

  end
end
