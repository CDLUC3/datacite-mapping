#!/usr/bin/env ruby
# frozen_string_literal: true

require 'datacite/mapping'
include Datacite::Mapping

# Based on "Example for a simple dataset"
# http://schema.datacite.org/meta/kernel-3/example/datacite-example-dataset-v3.0.xml
resource = Resource.new(
  identifier: Identifier.new(value: '10.5072/D3P26Q35R-Test'),
  creators: [
    Creator.new(name: 'Fosmire, Michael'),
    Creator.new(name: 'Wertz, Ruth'),
    Creator.new(name: 'Purzer, Senay')
  ],
  titles: [
    Title.new(value: 'Critical Engineering Literacy Test (CELT)')
  ],
  publisher: 'Purdue University Research Repository (PURR)',
  publication_year: 2013,
  subjects: [
    Subject.new(value: 'Assessment'),
    Subject.new(value: 'Information Literacy'),
    Subject.new(value: 'Engineering'),
    Subject.new(value: 'Undergraduate Students'),
    Subject.new(value: 'CELT'),
    Subject.new(value: 'Purdue University')
  ],
  language: 'en',
  resource_type: ResourceType.new(resource_type_general: ResourceTypeGeneral::DATASET, value: 'Dataset'),
  version: '1',
  descriptions: [
    Description.new(
      type: DescriptionType::ABSTRACT,
      value: 'We developed an instrument, Critical Engineering Literacy Test (CELT), which is a multiple choice instrument
              designed to measure undergraduate students’ scientific and information literacy skills. It requires students to
              first read a technical memo and, based on the memo’s arguments, answer eight multiple choice and six open-ended
              response questions. We collected data from 143 first-year engineering students and conducted an item analysis. The
              KR-20 reliability of the instrument was .39. Item difficulties ranged between .17 to .83. The results indicate low
              reliability index but acceptable levels of item difficulties and item discrimination indices. Students were most
              challenged when answering items measuring scientific and mathematical literacy (i.e., identifying incorrect
              information).'
    )
  ]
)

puts resource.write_xml
