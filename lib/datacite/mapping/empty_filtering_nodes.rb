require 'xml/mapping_extensions'

module Datacite
  module Mapping

    module EmptyNodeUtils
      def not_empty(element)
        return unless element
        text = element.text
        empty = text.nil? || text.strip.empty?
        warn "Ignoring empty element #{element}" if empty
        !empty
      end
    end

    # An {XML::Mapping::ArrayNode} that ignores empty tags, including tags
    # containing only blank text.
    class EmptyFilteringArrayNode < XML::Mapping::ArrayNode
      include EmptyNodeUtils
      def extract_attr_value(xml)
        elements = default_when_xpath_err { @reader_path.all(xml) }
        non_empty_elements = elements.select { |e| not_empty(e) }
        non_empty_elements.map { |e| unmarshal(e) }
      end

      def unmarshal(element)
        @unmarshaller.call(element)
      end
    end
    XML::Mapping.add_node_class EmptyFilteringArrayNode
  end
end
