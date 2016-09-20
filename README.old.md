# datacite-mapping

[![Build Status](https://travis-ci.org/CDLUC3/datacite-mapping.png?branch=master)](https://travis-ci.org/CDLUC3/datacite-mapping)
[![Code Climate](https://codeclimate.com/github/CDLUC3/datacite-mapping.png)](https://codeclimate.com/github/CDLUC3/datacite-mapping)
[![Inline docs](http://inch-ci.org/github/CDLUC3/datacite-mapping.png)](http://inch-ci.org/github/CDLUC3/datacite-mapping)
[![Gem Version](https://img.shields.io/gem/v/datacite-mapping.svg)](https://github.com/CDLUC3/datacite-mapping/releases)

A library for mapping [DataCite XML](http://schema.datacite.org/meta/kernel-3/) to Ruby objects.
Full API documentation on [RubyDoc.info](http://www.rubydoc.info/github/CDLUC3/datacite-mapping/master/frames).

## Reading

```ruby
require 'datacite/mapping'

include Datacite::Mapping

File.open('resource.xml', 'r') do |xml_file|
  resource = Resource.parse_xml(xml_file)

  creators = resource.creators
  citation = ''
  citation << creators.map(&:name).join('; ')
  citation << ' '
  citation << "(#{resource.publication_year})"
  citation << ': '
  title = resource.titles[0].value
  citation << title
  citation << (title.end_with?('.') ? ' ' : '. ')
  citation << resource.publisher

  puts("Citation: #{citation}")

  abstract = resource.descriptions.find { |d| d.type = DescriptionType::ABSTRACT }
  puts("Abstract: #{abstract.value}")
end
```

Results:

```
Citation: Schumann, Kai; Völker, David; Weinrebe, Wilhelm Reiber (2011):
Gridded results of swath bathymetric mapping of Disko Bay, Western
Greenland, 2007-2008. PANGAEA - Data Publisher for Earth & Environmental
Science

Abstract: A ship-based acoustic mapping campaign was conducted at the exit
of Ilulissat Ice Fjord and in the sedimentary basin of Disko Bay to the
west of the fjord mouth. Submarine landscape and sediment distribution
patterns are interpreted in terms of glaciomarine facies types that are
related to variations in the past position of the glacier front. In
particular, asymmetric ridges that form a curved entity and a large sill at
the fjord mouth may represent moraines that depict at least two relatively
stable positions of the ice front in the Disko Bay and at the fjord mouth.
In this respect, Ilulissat Glacier shows prominent differences to the East
Greenland Kangerlussuaq Glacier which is comparable in present size and
present role for the ice discharge from the inland ice sheet. Two linear
clusters of pockmarks in the center of the sedimentary basin seem to be
linked to ongoing methane release due to dissociation of gas hydrates, a
process fueled by climate warming in the Arctic realm.
```

## Writing

```ruby
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
      value: 'We developed an instrument, Critical Engineering Literacy Test
              (CELT), which is a multiple choice instrument designed to
              measure undergraduate students’ scientific and information
              literacy skills. It requires students to first read a
              technical memo and, based on the memo’s arguments, answer
              eight multiple choice and six open-ended response questions.
              We collected data from 143 first-year engineering students and
              conducted an item analysis. The KR-20 reliability of the
              instrument was .39. Item difficulties ranged between .17 to
              .83. The results indicate low reliability index but acceptable
              levels of item difficulties and item discrimination indices.
              Students were most challenged when answering items measuring
              scientific and mathematical literacy (i.e., identifying
              incorrect information).'
    )
  ]
)

puts resource.write_xml
```

Results:

```xml
<resource xmlns='http://datacite.org/schema/kernel-3' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:schemaLocation='http://datacite.org/schema/kernel-3 http://schema.datacite.org/meta/kernel-3/metadata.xsd'>
  <identifier identifierType='DOI'>10.5072/D3P26Q35R-Test</identifier>
  <creators>
    <creator>
      <creatorName>Fosmire, Michael</creatorName>
    </creator>
    <creator>
      <creatorName>Wertz, Ruth</creatorName>
    </creator>
    <creator>
      <creatorName>Purzer, Senay</creatorName>
    </creator>
  </creators>
  <titles>
    <title xml:lang='en'>Critical Engineering Literacy Test (CELT)</title>
  </titles>
  <publisher>Purdue University Research Repository (PURR)</publisher>
  <publicationYear>2013</publicationYear>
  <subjects>
    <subject xml:lang='en'>Assessment</subject>
    <subject xml:lang='en'>Information Literacy</subject>
    <subject xml:lang='en'>Engineering</subject>
    <subject xml:lang='en'>Undergraduate Students</subject>
    <subject xml:lang='en'>CELT</subject>
    <subject xml:lang='en'>Purdue University</subject>
  </subjects>
  <language>en</language>
  <resourceType resourceTypeGeneral='Dataset'>Dataset</resourceType>
  <version>1</version>
  <descriptions>
    <description xml:lang='en' descriptionType='Abstract'>
      We developed an instrument, Critical Engineering Literacy Test (CELT),
      which is a multiple choice instrument designed to measure undergraduate
      students’ scientific and information literacy skills. It requires students
      to first read a technical memo and, based on the memo’s arguments, answer
      eight multiple choice and six open-ended response questions. We collected
      data from 143 first-year engineering students and conducted an item
      analysis. The KR-20 reliability of the instrument was .39. Item
      difficulties ranged between .17 to .83. The results indicate low
      reliability index but acceptable levels of item difficulties and item
      discrimination indices. Students were most challenged when answering items
      measuring scientific and mathematical literacy (i.e., identifying
      incorrect information).
    </description>
  </descriptions>
</resource>
```

## Nonvalidating mapping (experimental)

Version 0.1.16 adds a `:nonvalidating` mapping, meant to deal with some issues we ran into with
old, noncompliant data files. Specifically, it parses identifiers and subjects without values:

```xml
<identifier type="DOI"/>
<subject schemeURI="http://www.nlm.nih.gov/mesh/" subjectScheme="MeSH"/>
```

The former are imported with a nil value; the latter are skipped.

```ruby
resource = Resource.parse_xml(xml_text, mapping: :nonvalidating)
resource.write_xml(mapping: :nonvalidating)
```

This isn't meant to be exhaustive, only to handle some specific cases we ran into with importing
old data. If you have additional cases, please file an issue, attaching sample documents, and
we'll try to accommodate them.
