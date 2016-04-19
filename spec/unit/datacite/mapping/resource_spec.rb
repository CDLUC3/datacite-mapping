# coding: utf-8
require 'spec_helper'

module Datacite
  module Mapping
    describe Resource do

      before :each do
        @id = Identifier.new(value: '10.14749/1407399495')
        @creators = [
          Creator.new(
            name: 'Hedy Lamarr',
            identifier: NameIdentifier.new(scheme: 'ISNI', scheme_uri: URI('http://isni.org/'), value: '0000-0001-1690-159X'),
            affiliations: ['United Artists', 'Metro-Goldwyn-Mayer']
          ),
          Creator.new(
            name: 'Herschlag, Natalie',
            identifier: NameIdentifier.new(scheme: 'ISNI', scheme_uri: URI('http://isni.org/'), value: '0000-0001-0907-8419'),
            affiliations: ['Gaumont Buena Vista International', '20th Century Fox']
          )
        ]
        @titles = [
          Title.new(value: 'An Account of a Very Odd Monstrous Calf', language: 'en-emodeng'),
          Title.new(type: TitleType::SUBTITLE, value: 'And a Contest between Two Artists about Optick Glasses, &c', language: 'en-emodeng')
        ]
        @publisher = 'California Digital Library'
        @pub_year = 2015
      end

      # TODO: double-check all required/optional attributes

      it 'correctly differentiates required and optional attributes'

      # Required:
      #
      # <xs:element name="resource">
      # <xs:element name="identifier">
      # <xs:element name="creators">
      # <xs:element name="creator" maxOccurs="unbounded">
      # <xs:element name="creatorName">
      # <xs:element name="titles">
      # <xs:element name="title" maxOccurs="unbounded">
      # <xs:element name="publisher">
      # <xs:element name="publicationYear">
      # <xs:element name="contributorName">

      # Optional:
      #
      # <xs:element name="nameIdentifier" minOccurs="0">
      # <xs:element name="affiliation" minOccurs="0" maxOccurs="unbounded"/>
      # <xs:element name="subjects" minOccurs="0">
      # <xs:element name="subject" minOccurs="0" maxOccurs="unbounded">
      # <xs:element name="contributors" minOccurs="0">
      # <xs:element name="contributor" minOccurs="0" maxOccurs="unbounded">
      # <xs:element name="nameIdentifier" minOccurs="0">
      # <xs:element name="affiliation" minOccurs="0" maxOccurs="unbounded"/>
      # <xs:element name="dates" minOccurs="0">
      # <xs:element name="date" minOccurs="0" maxOccurs="unbounded">
      # <xs:element name="language" type="xs:language" minOccurs="0">
      # <xs:element name="resourceType" minOccurs="0">
      # <xs:element name="alternateIdentifiers" minOccurs="0">
      # <xs:element name="alternateIdentifier" minOccurs="0" maxOccurs="unbounded">
      # <xs:element name="relatedIdentifiers" minOccurs="0">
      # <xs:element name="relatedIdentifier" minOccurs="0" maxOccurs="unbounded">
      # <xs:element name="sizes" minOccurs="0">
      # <xs:element name="size" type="xs:string" minOccurs="0" maxOccurs="unbounded">
      # <xs:element name="formats" minOccurs="0">
      # <xs:element name="format" type="xs:string" minOccurs="0" maxOccurs="unbounded">
      # <xs:element name="version" type="xs:string" minOccurs="0">
      # <xs:element name="rightsList" minOccurs="0">
      # <xs:element name="rights" minOccurs="0" maxOccurs="unbounded">
      # <xs:element name="descriptions" minOccurs="0">
      # <xs:element name="description" minOccurs="0" maxOccurs="unbounded">
      # <xs:element name="br" minOccurs="0" maxOccurs="unbounded">
      # <xs:element name="geoLocations" minOccurs="0">
      # <xs:element name="geoLocation" minOccurs="0" maxOccurs="unbounded">
      # <xs:element name="geoLocationPoint" type="point" minOccurs="0"/>
      # <xs:element name="geoLocationBox" type="box" minOccurs="0"/>
      # <xs:element name="geoLocationPlace" minOccurs="0"/>

      describe '#initialize' do
        it 'sets the identifier' do
          resource = Resource.new(
            identifier: @id,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year
          )
          expect(resource.identifier).to eq(@id)
          expect(resource.save_to_xml).to be_a(REXML::Element) # sanity check
        end

        it 'sets the creators' do
          resource = Resource.new(
            identifier: @id,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year
          )
          expect(resource.creators).to eq(@creators)
          expect(resource.save_to_xml).to be_a(REXML::Element) # sanity check
        end

        it 'sets the titles' do
          resource = Resource.new(
            identifier: @id,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year
          )
          expect(resource.titles).to eq(@titles)
          expect(resource.save_to_xml).to be_a(REXML::Element) # sanity check
        end

        it 'sets the publisher' do
          resource = Resource.new(
            identifier: @id,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year
          )
          expect(resource.publisher).to eq(@publisher)
          expect(resource.save_to_xml).to be_a(REXML::Element) # sanity check
        end

        it 'sets the publicationYear' do
          resource = Resource.new(
            identifier: @id,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year
          )
          expect(resource.publication_year).to eq(@pub_year)
          expect(resource.save_to_xml).to be_a(REXML::Element) # sanity check
        end

        it 'requires an identifier' do
          expect do
            Resource.new(
              creators: @creators,
              titles: @titles,
              publisher: @publisher,
              publication_year: @pub_year
            )
          end.to raise_error(ArgumentError)
          expect do
            Resource.new(
              creators: @creators,
              titles: @titles,
              publisher: @publisher,
              publication_year: @pub_year,
              identifier: nil
            )
          end.to raise_error(ArgumentError)
        end

        it 'requires creators' do
          expect do
            Resource.new(
              identifier: @id,
              titles: @titles,
              publisher: @publisher,
              publication_year: @pub_year
            )
          end.to raise_error(ArgumentError)
          expect do
            Resource.new(
              identifier: @id,
              titles: @titles,
              publisher: @publisher,
              publication_year: @pub_year,
              creators: []
            )
          end.to raise_error(ArgumentError)
          expect do
            Resource.new(
              identifier: @id,
              titles: @titles,
              publisher: @publisher,
              publication_year: @pub_year,
              creators: nil
            )
          end.to raise_error(ArgumentError)
        end

        it 'requires titles' do
          expect do
            Resource.new(
              identifier: @id,
              creators: @creators,
              publisher: @publisher,
              publication_year: @pub_year
            )
          end.to raise_error(ArgumentError)
          expect do
            Resource.new(
              identifier: @id,
              creators: @creators,
              publisher: @publisher,
              publication_year: @pub_year,
              titles: nil
            )
          end.to raise_error(ArgumentError)
          expect do
            Resource.new(
              identifier: @id,
              creators: @creators,
              publisher: @publisher,
              publication_year: @pub_year,
              titles: []
            )
          end.to raise_error(ArgumentError)
        end

        it 'requires a publisher' do
          expect do
            Resource.new(
              identifier: @id,
              creators: @creators,
              titles: @titles,
              publication_year: @pub_year
            )
          end.to raise_error(ArgumentError)
          expect do
            Resource.new(
              identifier: @id,
              creators: @creators,
              titles: @titles,
              publication_year: @pub_year,
              publisher: nil
            )
          end.to raise_error(ArgumentError)
          expect do
            Resource.new(
              identifier: @id,
              creators: @creators,
              titles: @titles,
              publication_year: @pub_year,
              publisher: []
            )
          end.to raise_error(ArgumentError)
          expect do
            Resource.new(
              identifier: @id,
              creators: @creators,
              titles: @titles,
              publication_year: @pub_year,
              publisher: ''
            )
          end.to raise_error(ArgumentError)
        end

        it 'requires a publicationYear' do
          expect do
            Resource.new(
              identifier: @id,
              creators: @creators,
              titles: @titles,
              publisher: @publisher
            )
          end.to raise_error(ArgumentError)
          expect do
            Resource.new(
              identifier: @id,
              creators: @creators,
              titles: @titles,
              publisher: @publisher,
              publication_year: nil
            )
          end.to raise_error(ArgumentError)
          expect do
            Resource.new(
              identifier: @id,
              creators: @creators,
              titles: @titles,
              publisher: @publisher,
              publication_year: -1
            )
          end.to raise_error(ArgumentError)
          expect do
            Resource.new(
              identifier: @id,
              creators: @creators,
              titles: @titles,
              publisher: @publisher,
              publication_year: 999
            )
          end.to raise_error(ArgumentError)
          expect do
            Resource.new(
              identifier: @id,
              creators: @creators,
              titles: @titles,
              publisher: @publisher,
              publication_year: 10_000
            )
          end.to raise_error(ArgumentError)
        end

        it 'allows subjects' do
          subjects = [
            Subject.new(
              language: 'en-us',
              scheme: 'LCSH',
              scheme_uri: URI('http://id.loc.gov/authorities/subjects'),
              value: 'Mammals--Embryology'
            ),
            Subject.new(
              language: 'fr',
              scheme: 'dewey',
              scheme_uri: URI('http://dewey.info/'),
              value: '571.8 Croissance, développement, reproduction biologique (fécondation, sexualité)'
            )
          ]
          resource = Resource.new(
            identifier: @id,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year,
            subjects: subjects
          )
          expect(resource.subjects).to eq(subjects)
          expect(resource.save_to_xml).to be_a(REXML::Element) # sanity check
        end

        it 'allows dates' do
          dates = [
            Date.new(value: DateTime.new(1914, 8, 4, 11, 01, 6.0123, '+1'), type: DateType::AVAILABLE),
            Date.new(value: '1914-08-04T11:01:06.0123+01:00', type: DateType::AVAILABLE)
          ]
          resource = Resource.new(
            identifier: @id,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year,
            dates: dates
          )
          expect(resource.dates).to eq(dates)
          expect(resource.save_to_xml).to be_a(REXML::Element) # sanity check
        end

        it 'allows a language' do
          resource = Resource.new(
            identifier: @id,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year,
            language: 'en-emodeng'
          )
          expect(resource.language).to eq('en-emodeng')
          expect(resource.save_to_xml).to be_a(REXML::Element) # sanity check
        end

        it 'allows alternate identifiers' do
          alternate_identifiers = [
            AlternateIdentifier.new(type: 'URL', value: 'http://example.org'),
            AlternateIdentifier.new(type: 'URL', value: 'http://example.com')
          ]
          resource = Resource.new(
            identifier: @id,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year,
            alternate_identifiers: alternate_identifiers
          )
          expect(resource.alternate_identifiers).to eq(alternate_identifiers)
          expect(resource.save_to_xml).to be_a(REXML::Element) # sanity check
        end

        it 'allows sizes' do
          sizes = ['2 petabytes', '2048 TB']
          resource = Resource.new(
            identifier: @id,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year,
            sizes: sizes
          )
          expect(resource.sizes).to eq(sizes)
          expect(resource.save_to_xml).to be_a(REXML::Element) # sanity check
        end

        it 'allows related identifiers' do
          related_identifiers = [
            RelatedIdentifier.new(
              identifier_type: RelatedIdentifierType::URL,
              relation_type: RelationType::HAS_METADATA,
              related_metadata_scheme: 'citeproc+json',
              scheme_type: 'Turtle',
              scheme_uri: URI('https://github.com/citation-style-language/schema/raw/master/csl-data.json'),
              value: 'http://data.datacite.org/application/citeproc+json/10.5072/example-full'
            ),
            RelatedIdentifier.new(
              identifier_type: RelatedIdentifierType::ARXIV,
              relation_type: RelationType::IS_REVIEWED_BY,
              value: 'arXiv:0706.0001'
            )
          ]
          resource = Resource.new(
            identifier: @id,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year,
            related_identifiers: related_identifiers
          )
          expect(resource.related_identifiers).to eq(related_identifiers)
          expect(resource.save_to_xml).to be_a(REXML::Element) # sanity check
        end

        it 'allows formats' do
          formats = %w(application/xml text/html)
          resource = Resource.new(
            identifier: @id,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year,
            formats: formats
          )
          expect(resource.formats).to eq(formats)
          expect(resource.save_to_xml).to be_a(REXML::Element) # sanity check
        end

        it 'allows a version' do
          version = '3.1'
          resource = Resource.new(
            identifier: @id,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year,
            version: version
          )
          expect(resource.version).to eq(version)
          expect(resource.save_to_xml).to be_a(REXML::Element) # sanity check
        end

        it 'allows rights' do
          rights_list = [
            Rights.new(value: 'CC0 1.0 Universal', uri: URI('http://creativecommons.org/publicdomain/zero/1.0/')),
            Rights.new(value: 'This work is free of known copyright restrictions.', uri: URI('http://creativecommons.org/publicdomain/mark/1.0/'))
          ]
          resource = Resource.new(
            identifier: @id,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year,
            rights_list: rights_list
          )
          expect(resource.rights_list).to eq(rights_list)
          expect(resource.save_to_xml).to be_a(REXML::Element) # sanity check
        end
      end

      describe '#parse_xml' do
        before(:each) do
          identifier = Identifier.new(value: '10.5072/example-full').save_to_xml

          creators = REXML::Element.new('creators')
          creators.add_element(Creator.new(
            name: 'Miller, Elizabeth',
            identifier: NameIdentifier.new(scheme: 'ORCID', scheme_uri: URI('http://orcid.org'), value: '0000-0001-5000-0007'),
            affiliations: ['DataCite']
          ).save_to_xml)

          titles = REXML::Element.new('titles')
          titles.add_element(Title.new(
            language: 'en-us',
            value: 'Full DataCite XML Example'
          ).save_to_xml)
          titles.add_element(Title.new(
            language: 'en-us',
            type: TitleType::SUBTITLE,
            value: 'Demonstration of DataCite Properties.'
          ).save_to_xml)

          publisher = REXML::Element.new('publisher')
          publisher.text = 'DataCite'

          publication_year = REXML::Element.new('publicationYear')
          publication_year.text = '2014'

          resource = REXML::Element.new('resource')
          resource.add_namespace('http://datacite.org/schema/kernel-3')
          resource.add_namespace('xsi', 'http://www.w3.org/2001/XMLSchema-instance')
          resource.add_attribute('xsi:schemaLocation', 'http://datacite.org/schema/kernel-3 http://schema.datacite.org/meta/kernel-3/metadata.xsd')
          resource.add_element(identifier)
          resource.add_element(creators)
          resource.add_element(titles)
          resource.add_element(publisher)
          resource.add_element(publication_year)

          @required_xml = resource
        end

        it 'parses a resource with only required attributes' do
          resource = Resource.parse_xml(@required_xml)
          expect(resource.language).to eq('en')
        end

        it 'correctly differentiates required and optional attributes'
      end

      describe '#save_to_xml' do
        it 'sets the namespace to http://datacite.org/schema/kernel-3'
        it "doesn't clobber the namespace on the various xml:lang attributes"
      end

      describe 'identifier' do
        it 'returns the identifier'
      end

      describe 'identifier=' do
        it 'sets the identifier'
        it 'rejects nil'
      end

      describe 'creators' do
        it 'returns the creator list'
        it 'returns an editable list'
      end

      describe 'creators=' do
        it 'overwrites the creator list'
        it 'requires at least one creator'
      end

      describe 'titles' do
        it 'returns the title list'
        it 'returns an editable list'
      end

      describe 'titles=' do
        it 'overwrites the title list'
        it 'requires at least one title'
      end

      describe 'publisher' do
        it 'returns the publisher'
      end

      describe 'publisher=' do
        it 'sets the publisher'
        it 'rejects nil'
        it 'rejects the empty string'
      end

      describe 'publication_year' do
        it 'returns the publication year'
        it 'rejects nil'
        it 'accepts only 4-digit integers'
      end

      describe 'publication_year=' do
        it 'sets the publication year'
      end

      describe 'subjects' do
        it 'returns the subject list'
        it 'returns an editable list'
      end

      describe 'subjects=' do
        it 'overwrites the subject list'
        it 'accepts an empty list'
      end

      describe 'dates' do
        it 'returns the date list'
        it 'returns an editable list'
      end

      describe 'dates=' do
        it 'overwrites the date list'
        it 'accepts an empty list'
      end

      describe 'language' do
        it 'returns the language'
      end

      describe 'language=' do
        it 'sets the languge'
        it 'requires a language'
      end

      describe 'resource_type' do
        it 'returns the resource type'
      end

      describe 'resource_type=' do
        it 'sets the resource type'
        it 'requires a resource type'
      end

      describe 'alternate_identifiers' do
        it 'returns the alternate identifier list'
        it 'returns an editable list'
      end

      describe 'alternate_identifiers=' do
        it 'overwrites the alternate identifier list'
        it 'accepts an empty list'
      end

      describe 'related_identifiers' do
        it 'returns the related identifier list'
        it 'returns an editable list'
      end

      describe 'related_identifiers=' do
        it 'overwrites the related identifier list'
        it 'accepts an empty list'
      end

      describe 'sizes' do
        it 'returns the size list'
        it 'returns an editable list'
      end

      describe 'sizes=' do
        it 'overwrites the size list'
        it 'accepts an empty list'
      end

      describe 'formats' do
        it 'returns the size list'
        it 'returns an editable list'
      end

      describe 'formats=' do
        it 'overwrites the size list'
        it 'accepts an empty list'
      end

      describe 'version' do
        it 'returns the version'
      end

      describe 'version=' do
        it 'sets the languge'
        it 'accepts nil'
      end

      describe 'rights' do
        it 'returns the rights list'
        it 'returns an editable list'
      end

      describe 'rights=' do
        it 'overwrites the rights list'
        it 'accepts an empty list'
      end

      describe 'descriptions' do
        it 'returns the description list'
        it 'returns an editable list'
      end

      describe 'descriptions=' do
        it 'overwrites the description list'
        it 'accepts an empty list'
      end

      describe 'geo_locations' do
        it 'returns the geolocation list'
        it 'returns an editable list'
      end

      describe 'geo_locations=' do
        it 'overwrites the geolocation list'
        it 'accepts an empty list'
      end

      describe 'XML mapping' do

        describe '#save_to_xml' do
          it 'writes XML' do
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

            expected_xml = '<resource xsi:schemaLocation="http://datacite.org/schema/kernel-3 http://schema.datacite.org/meta/kernel-3/metadata.xsd" xmlns="http://datacite.org/schema/kernel-3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                              <identifier identifierType="DOI">10.5072/D3P26Q35R-Test</identifier>
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
                                <title xml:lang="en">Critical Engineering Literacy Test (CELT)</title>
                              </titles>
                              <publisher>Purdue University Research Repository (PURR)</publisher>
                              <publicationYear>2013</publicationYear>
                              <subjects>
                                <subject xml:lang="en">Assessment</subject>
                                <subject xml:lang="en">Information Literacy</subject>
                                <subject xml:lang="en">Engineering</subject>
                                <subject xml:lang="en">Undergraduate Students</subject>
                                <subject xml:lang="en">CELT</subject>
                                <subject xml:lang="en">Purdue University</subject>
                              </subjects>
                              <language>en</language>
                              <resourceType resourceTypeGeneral="Dataset">Dataset</resourceType>
                              <version>1</version>
                              <descriptions>
                                <description descriptionType="Abstract" xml:lang="en">We developed an instrument, Critical Engineering Literacy Test (CELT), which is a multiple choice instrument designed to measure undergraduate students’ scientific and information literacy skills. It requires students to first read a technical memo and, based on the memo’s arguments, answer eight multiple choice and six open-ended response questions. We collected data from 143 first-year engineering students and conducted an item analysis. The KR-20 reliability of the instrument was .39. Item difficulties ranged between .17 to .83. The results indicate low reliability index but acceptable levels of item difficulties and item discrimination indices. Students were most challenged when answering items measuring scientific and mathematical literacy (i.e., identifying incorrect information).</description>
                              </descriptions>
                            </resource>'

            expect(resource.save_to_xml).to be_xml(expected_xml)
          end
        end

        it 'round-trips' do
          xml_text = File.read('spec/data/resource.xml')
          resource = Resource.parse_xml(xml_text)
          expect(resource.save_to_xml).to be_xml(xml_text)
        end
      end

      describe 'convenience accessors' do

        before :each do
          xml_text = File.read('spec/data/resource.xml')
          @resource = Resource.parse_xml(xml_text)

          @funder = Contributor.new(
            name: 'The Ministry of Magic',
            identifier: NameIdentifier.new(
              scheme: 'IATI',
              scheme_uri: URI('http://iatistandard.org/201/codelists/OrganisationIdentifier/'),
              value: 'GR-9¾'
            ),
            type: ContributorType::FUNDER)
          @resource.contributors << @funder
        end

        describe 'creator_names' do
          it 'extracts the creator names' do
            expect(@resource.creator_names).to eq(['Miller, Elizabeth'])
          end
        end

        describe 'creator_affiliations' do
          it 'extracts the creator affiliations' do
            expect(@resource.creator_affiliations).to eq([['DataCite']])
          end
        end

        describe 'funder_contrib' do
          it 'extracts the funder contrib' do
            expect(@resource.funder_contrib).to eq(@funder)
          end
        end

        describe 'funder_name' do
          it 'extracts the funder name' do
            expect(@resource.funder_name).to eq(@funder.name)
          end
        end

        describe 'funder_id' do
          it 'extracts the funder id' do
            expect(@resource.funder_id).to eq(@funder.identifier)
          end
        end

        describe 'funder_id_value' do
          it 'extracts the funder id value' do
            expect(@resource.funder_id_value).to eq(@funder.identifier.value)
          end
        end
      end
    end
  end
end
