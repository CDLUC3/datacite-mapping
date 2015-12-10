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
            identifier: @identifier,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year
          )
          expect(resource.identifier).to eq(@identifier)
        end

        it 'sets the creators' do
          resource = Resource.new(
            identifier: @identifier,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year
          )
          expect(resource.creators).to eq(@creators)
        end

        it 'sets the titles' do
          resource = Resource.new(
            identifier: @identifier,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year
          )
          expect(resource.titles).to eq(@titles)
        end

        it 'sets the publisher' do
          resource = Resource.new(
            identifier: @identifier,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year
          )
          expect(resource.publisher).to eq(@publisher)
        end

        it 'sets the publicationYear' do
          resource = Resource.new(
            identifier: @identifier,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year
          )
          expect(resource.publication_year).to eq(@pub_year)
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
        end

        it 'requires creators' do
          expect do
            Resource.new(
              identifier: @identifier,
              titles: @titles,
              publisher: @publisher,
              publication_year: @pub_year
            )
          end.to raise_error(ArgumentError)
        end

        it 'requires titles' do
          expect do
            Resource.new(
              identifier: @identifier,
              creators: @creators,
              publisher: @publisher,
              publication_year: @pub_year
            )
          end.to raise_error(ArgumentError)
        end

        it 'requires a publisher' do
          expect do
            Resource.new(
              identifier: @identifier,
              creators: @creators,
              titles: @titles,
              publication_year: @pub_year
            )
          end.to raise_error(ArgumentError)
        end

        it 'requires a publicationYear' do
          expect do
            Resource.new(
              identifier: @identifier,
              creators: @creators,
              titles: @titles,
              publisher: @publisher
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
            identifier: @identifier,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year,
            subjects: subjects
          )
          expect(resource.subjects).to eq(subjects)
        end

        it 'allows dates' do
          dates = [
            Date.new(value: DateTime.new(1914, 8, 4, 11, 01, 6.0123, '+1'), type: DateType::AVAILABLE),
            Date.new(value: '1914-08-04T11:01:06.0123+01:00', type: DateType::AVAILABLE)
          ]
          resource = Resource.new(
            identifier: @identifier,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year,
            dates: dates
          )
          expect(resource.dates).to eq(dates)
        end

        it 'allows a language' do
          resource = Resource.new(
            identifier: @identifier,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year,
            language: 'en-emodeng'
          )
          expect(resource.language).to eq('en-emodeng')
        end

        it 'allows alternate identifiers' do
          alternate_identifiers = [
            AlternateIdentifier.new(type: 'URL', value: 'http://example.org'),
            AlternateIdentifier.new(type: 'URL', value: 'http://example.com')
          ]
          resource = Resource.new(
            identifier: @identifier,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year,
            alternate_identifiers: alternate_identifiers
          )
          expect(resource.alternate_identifiers).to eq(alternate_identifiers)
        end

        it 'allows sizes' do
          sizes = ['2 petabytes', '2048 TB']
          resource = Resource.new(
            identifier: @identifier,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year,
            sizes: sizes
          )
          expect(resource.sizes).to eq(sizes)
        end

        it 'allows related identifiers' do
          related_identifiers = [
            RelatedIdentifier.new(
              identifier_type: 'URL',
              relation_type: RelationType::HAS_METADATA,
              related_metadata_scheme: 'citeproc+json',
              scheme_type: 'Turtle',
              scheme_uri: URI('https://github.com/citation-style-language/schema/raw/master/csl-data.json'),
              value: 'http://data.datacite.org/application/citeproc+json/10.5072/example-full'
            ),
            RelatedIdentifier.new(
              identifier_type: 'arXiv',
              relation_type: RelationType::IS_REVIEWED_BY,
              value: 'arXiv:0706.0001'
            )
          ]
          resource = Resource.new(
            identifier: @identifier,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year,
            related_identifiers: related_identifiers
          )
          expect(resource.related_identifiers).to eq(related_identifiers)
        end

        it 'allows formats' do
          formats = %w(application/xml text/html)
          resource = Resource.new(
            identifier: @identifier,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year,
            formats: formats
          )
          expect(resource.formats).to eq(formats)
        end

        it 'allows a version' do
          version = '3.1'
          resource = Resource.new(
            identifier: @identifier,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year,
            version: version
          )
          expect(resource.version).to eq(version)
        end

        it 'allows rights' do
          rights_list = [
            Rights.new(value: 'CC0 1.0 Universal', uri: URI('http://creativecommons.org/publicdomain/zero/1.0/')),
            Rights.new(value: 'This work is free of known copyright restrictions.', uri: URI('http://creativecommons.org/publicdomain/mark/1.0/'))
          ]
          resource = Resource.new(
            identifier: @identifier,
            creators: @creators,
            titles: @titles,
            publisher: @publisher,
            publication_year: @pub_year,
            rights_list: rights_list
          )
          expect(resource.rights_list).to eq(rights_list)
        end
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
        it 'round-trips' do
          xml_text = File.read('spec/data/resource.xml')
          xml = REXML::Document.new(xml_text).root
          resource = Resource.load_from_xml(xml)
          expect(resource.save_to_xml).to be_xml(xml_text)
        end
      end
    end
  end
end
