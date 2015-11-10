require 'xml/mapping'
require_relative 'identifier'
require_relative 'creators'

module Datacite
  module Mapping
    class Resource
      include ::XML::Mapping

      object_node :identifier, 'identifier', class: Identifier
      object_node :creator_list, 'creators', class: Creators

      def creators=(value)
        self.creator_list = Creators.new(creators: value)
      end

      def creators
        [] unless creator_list
        creator_list.creators
      end
    end
  end
end
