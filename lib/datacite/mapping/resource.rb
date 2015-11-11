require 'xml/mapping'
require_relative 'identifier'
require_relative 'creator'
require_relative 'title'

module Datacite
  module Mapping
    class Resource
      include ::XML::Mapping

      object_node :identifier, 'identifier', class: Identifier
      object_node :_creators, 'creators', class: Creators
      object_node :_titles, 'titles', class: Titles

      def creators=(value)
        self._creators = Creators.new(creators: value)
      end

      def creators
        _creators ||= Creators.new(creators: [])
        _creators.creators
      end

      def titles=(value)
        self._titles = Titles.new(titles: value)
      end

      def titles
        _titles ||= Titles.new(titles: [])
        _titles.titles
      end

    end
  end
end
