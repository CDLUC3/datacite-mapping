require 'xml/mapping'
require_relative 'creator'

module Datacite
  module Mapping
    # Not to be instantiated directly -- just call `Resource#creators`
    class Creators
      include ::XML::Mapping
      array_node :creators, 'creator', class: Creator

      def initialize(creators:)
        self.creators = creators
      end
    end
  end
end
