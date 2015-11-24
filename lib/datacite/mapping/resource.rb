require 'xml/mapping'
require_relative 'identifier'
require_relative 'creator'
require_relative 'title'
require_relative 'subject'

module Datacite
  module Mapping
    class Resource
      include XML::Mapping

      object_node :identifier, 'identifier', class: Identifier
      object_node :_creators, 'creators', class: Creators
      object_node :_titles, 'titles', class: Titles
      text_node :publisher, 'publisher'
      numeric_node :publication_year, 'publicationYear'
      object_node :_subjects, 'subjects', class: Subjects
      text_node :_lang, 'language'

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

      def subjects=(value)
        self._subjects = Subjects.new(subjects: value)
      end

      def subjects
        _subjects ||= Subjects.new(subjects: [])
        _subjects.subjects
      end

      def language
        _lang || 'en'
      end

      def language=(value)
        fail ArgumentError, 'Language cannot be nil' unless value
        self._lang = value
      end

    end
  end
end
