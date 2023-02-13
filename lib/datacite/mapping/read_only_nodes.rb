# frozen_string_literal: true

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

      def value_from(obj)
        obj.send(@attrname)
      end

      def value_str(val)
        return "[ #{val.map(&:to_s).join(', ')} ]" if val.is_a?(Array)

        "'#{val}'"
      end

      def obj_to_xml(obj, _xml)
        val = value_from(obj)
        return unless val

        warn_ignored(val)
      end

      def warn_ignored(val)
        warning = "ignoring #{@attrname} #{value_str(val)}"
        warning = "#{warn_reason}; #{warning}" if warn_reason
        ReadOnlyNodes.warn(warning)
      end

      # rubocop:disable Lint/UselessMethodDefinition
      # public to allow testing
      def self.warn(warning)
        super
      end

      # rubocop:enable Lint/UselessMethodDefinition
    end

    class ReadOnlyTextNode < XML::Mapping::TextNode
      def warn_ignored(val)
        raise ArgumentError, "Expected string, got #{val}" unless val.respond_to?(:strip)
        return if val.strip.empty?

        super
      end
      include ReadOnlyNodes
    end
    XML::Mapping.add_node_class ReadOnlyTextNode

    class ReadOnlyArrayNode < XML::Mapping::ArrayNode
      def warn_ignored(val)
        raise ArgumentError, "Expected array, got #{val}" unless val.respond_to?(:empty?)
        return if val.empty?

        super
      end
      include ReadOnlyNodes
    end
    XML::Mapping.add_node_class ReadOnlyArrayNode

  end
end
