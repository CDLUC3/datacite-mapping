# coding: utf-8
require 'spec_helper'

module Datacite
  module Mapping
    describe Resource do

      attr_reader :creators
      attr_reader :args

      before(:each) do
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

        @args = {
          creators: creators
        }
      end

      describe '#creators' do
        it 'requires a non-nil creator list' do
          args[:creators] = nil
          expect { Resource.new(args) }.to raise_error(ArgumentError)
        end

        it 'requires a non-empty creator list' do
          args[:creators] = []
          expect { Resource.new(args) }.to raise_error(ArgumentError)
        end

        it 'can be initialized' do
          resource = Resource.new(args)
          expect(resource.creators).to eq(creators)
          expect(resource.save_to_xml).to be_a(REXML::Element) # sanity check
        end

        it 'can be set' do
          new_creators = [Creator.new(
            name: 'Danica McKellar',
            identifier: NameIdentifier.new(scheme: 'ISNI', scheme_uri: URI('http://isni.org/'), value: '0000 0001 1678 4522'),
            affiliations: ['Disney–ABC Television Group']
          )]
          resource = Resource.new(args)
          resource.creators = new_creators
          expect(resource.creators).to eq(new_creators)
        end
      end

      describe '#alternate_identifiers' do
        it 'defaults to empty' do
          resource = Resource.new(args)
          expect(resource.alternate_identifiers).to eq([])
        end

        it 'can be initialized' do
          alternate_identifiers = [
            AlternateIdentifier.new(type: 'URL', value: 'http://example.org'),
            AlternateIdentifier.new(type: 'URL', value: 'http://example.com')
          ]
          args[:alternate_identifiers] = alternate_identifiers
          resource = Resource.new(args)
          expect(resource.alternate_identifiers).to eq(alternate_identifiers)
          expect(resource.save_to_xml).to be_a(REXML::Element) # sanity check
        end

        it 'can be set' do
          resource = Resource.new(args)
          alternate_identifiers = [
            AlternateIdentifier.new(type: 'URL', value: 'http://example.org'),
            AlternateIdentifier.new(type: 'URL', value: 'http://example.com')
          ]
          resource.alternate_identifiers = alternate_identifiers
          expect(resource.alternate_identifiers).to eq(alternate_identifiers)
        end
      end

      describe '#geo_locations' do
        it 'defaults to empty' do
          resource = Resource.new(args)
          expect(resource.geo_locations).to eq([])
        end

        it 'can be initialized' do
          geo_locations = [
            GeoLocation.new(point: GeoLocationPoint.new(47.61, -122.33)),
            GeoLocation.new(box: GeoLocationBox.new(-33.45, -122.33, 47.61, -70.67))
          ]
          args[:geo_locations] = geo_locations
          resource = Resource.new(args)
          expect(resource.geo_locations).to eq(geo_locations)
        end

        it 'can be set' do
          resource = Resource.new(args)
          geo_locations = [
            GeoLocation.new(point: GeoLocationPoint.new(47.61, -122.33)),
            GeoLocation.new(box: GeoLocationBox.new(-33.45, -122.33, 47.61, -70.67))
          ]
          resource.geo_locations = geo_locations
          expect(resource.geo_locations).to eq(geo_locations)
        end
      end

      describe 'DC3 support' do
        it 'reads a DC3 document'
        it 'reads a DC4 document'

        describe '#write_xml' do
          it 'sets the kernel-3 namespace'
          it 'writes a DC4 document as DC3'
          it 'warns about FundingReferences'
        end

        describe '#save_to_xml' do
          it 'sets the kernel-3 namespace'
          it 'writes a DC4 document as DC3'
          it 'warns about FundingReferences'
        end

        describe '#save_to_file' do
          it 'sets the kernel-3 namespace'
          it 'writes a DC4 document as DC3'
          it 'warns about FundingReferences'
        end
      end

      describe 'DC4 mapping' do
        it 'reads a DC4 document'
        it 'reads a DC3 document'

        describe '#write_xml' do
          it 'sets the kernel-4.0 namespace'
          it 'writes a DC3 document as DC4'
        end

        describe '#save_to_xml' do
          it 'sets the kernel-4.0 namespace'
          it 'writes a DC3 document as DC4'
        end

        describe '#save_to_file' do
          it 'sets the kernel-4.0 namespace'
          it 'writes a DC3 document as DC4'
        end
      end
    end
  end
end
