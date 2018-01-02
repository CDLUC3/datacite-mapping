# frozen_string_literal: true

require 'spec_helper'

module Datacite
  module Mapping
    describe Creator do

      describe '#initialize' do
        it 'sets the creator name' do
          creator = Creator.new(name: 'Hedy Lamarr')
          expect(creator.name).to eq('Hedy Lamarr')
        end

        it 'sets the identifier' do
          id = NameIdentifier.new(scheme: 'ISNI', scheme_uri: URI('http://isni.org/'), value: '0000-0001-1690-159X')
          creator = Creator.new(name: 'Hedy Lamarr', identifier: id)
          expect(creator.identifier).to eq(id)
        end

        it 'sets affiliations' do
          creator = Creator.new(name: 'Hedy Lamarr', affiliations: ['United Artists', 'Metro-Goldwyn-Mayer'])
          expect(creator.affiliations).to eq(['United Artists', 'Metro-Goldwyn-Mayer'])
        end

        it 'defaults to an empty affiliation array' do
          creator = Creator.new(name: 'Hedy Lamarr')
          expect(creator.affiliations).to eq([])
        end

        it 'sets the given and family names' do
          creator = Creator.new(name: 'Hedy Lamarr', given_name: 'Hedy', family_name: 'Lamarr')
          expect(creator.given_name).to eq('Hedy')
          expect(creator.family_name).to eq('Lamarr')
        end

        it 'defaults to nil given and family names' do

        end
      end

      describe '#name=' do
        it 'sets the name' do
          creator = Creator.allocate
          creator.name = 'Hedy Lamarr'
          expect(creator.name).to eq('Hedy Lamarr')
        end
        it 'rejects nil' do
          creator = Creator.new(name: 'Hedy Lamarr')
          expect { creator.name = nil }.to raise_error(ArgumentError)
          expect(creator.name).to eq('Hedy Lamarr')
        end
        it 'rejects empty' do
          creator = Creator.new(name: 'Hedy Lamarr')
          expect { creator.name = '' }.to raise_error(ArgumentError)
          expect(creator.name).to eq('Hedy Lamarr')
        end
        it 'strips' do
          creator = Creator.allocate
          creator.name = '
            Hedy Lamarr
          '
          expect(creator.name).to eq('Hedy Lamarr')
        end
      end

      describe '#given_name=' do
        it 'sets the given_name' do
          creator = Creator.allocate
          creator.given_name = 'Hedy'
          expect(creator.given_name).to eq('Hedy')
        end
        it 'strips' do
          creator = Creator.allocate
          creator.given_name = '
            Hedy
          '
          expect(creator.given_name).to eq('Hedy')
        end
      end

      describe '#family_name=' do
        it 'sets the family_name' do
          creator = Creator.allocate
          creator.family_name = 'Lamarr'
          expect(creator.family_name).to eq('Lamarr')
        end
        it 'strips' do
          creator = Creator.allocate
          creator.family_name = '
            Lamarr
          '
          expect(creator.family_name).to eq('Lamarr')
        end
      end

      describe '#identifier=' do
        it 'sets the identifier' do
          creator = Creator.new(name: 'Hedy Lamarr')
          identifier = NameIdentifier.new(scheme: 'ISNI', scheme_uri: URI('http://isni.org/'), value: '0000-0001-1690-159X')
          creator.identifier = identifier
          expect(creator.identifier).to eq(identifier)
        end
        it 'allows nil' do
          creator = Creator.new(name: 'Hedy Lamarr', identifier: NameIdentifier.new(scheme: 'ISNI', scheme_uri: URI('http://isni.org/'), value: '0000-0001-1690-159X'))
          creator.identifier = nil
          expect(creator.identifier).to be_nil
        end
      end

      describe '#affiliation=' do
        it 'sets affiliations' do
          creator = Creator.allocate
          affiliations = ['United Artists', 'Metro-Goldwyn-Mayer']
          creator.affiliations = affiliations
          expect(creator.affiliations).to eq(affiliations)
        end
        it 'treats nil as empty' do
          creator = Creator.new(name: 'Hedy Lamarr', affiliations: ['United Artists', 'Metro-Goldwyn-Mayer'])
          creator.affiliations = nil
          expect(creator.affiliations).to eq([])
        end
        it 'accepts an empty array' do
          creator = Creator.new(name: 'Hedy Lamarr', affiliations: ['United Artists', 'Metro-Goldwyn-Mayer'])
          creator.affiliations = []
          expect(creator.affiliations).to eq([])
        end
      end

      describe '#load_from_xml' do
        it 'parses XML' do
          xml_text = '<creator>
                        <creatorName>Hedy Lamarr</creatorName>
                        <nameIdentifier schemeURI="http://isni.org/" nameIdentifierScheme="ISNI">0000-0001-1690-159X</nameIdentifier>
                        <affiliation>United Artists</affiliation>
                        <affiliation>Metro-Goldwyn-Mayer</affiliation>
                      </creator>'
          creator = Creator.parse_xml(xml_text)
          expect(creator.name).to eq('Hedy Lamarr')
          expect(creator.affiliations).to eq(['United Artists', 'Metro-Goldwyn-Mayer'])
          id = creator.identifier
          expect(id.scheme).to eq('ISNI')
          expect(id.scheme_uri).to eq(URI('http://isni.org'))
          expect(id.value).to eq('0000-0001-1690-159X')
        end

        it 'defaults to an empty affiliation array' do
          xml_text = '<creator>
                        <creatorName>Hedy Lamarr</creatorName>
                        <nameIdentifier schemeURI="http://isni.org/" nameIdentifierScheme="ISNI">0000-0001-1690-159X</nameIdentifier>
                      </creator>'
          creator = Creator.parse_xml(xml_text)
          expect(creator.affiliations).to eq([])
        end
      end

      describe '#save_to_xml' do
        it 'writes XML' do
          id = NameIdentifier.new(scheme: 'ISNI', scheme_uri: URI('http://isni.org/'), value: '0000-0001-1690-159X')
          creator = Creator.new(name: 'Hedy Lamarr', identifier: id, affiliations: ['United Artists', 'Metro-Goldwyn-Mayer'])
          expected_xml = '<creator>
                            <creatorName>Hedy Lamarr</creatorName>
                            <nameIdentifier schemeURI="http://isni.org/" nameIdentifierScheme="ISNI">0000-0001-1690-159X</nameIdentifier>
                            <affiliation>United Artists</affiliation>
                            <affiliation>Metro-Goldwyn-Mayer</affiliation>
                          </creator>'
          expect(creator.save_to_xml).to be_xml(expected_xml)
        end
      end

      describe 'DC4 family and given names' do
        describe 'DC3 mapping' do
          it 'doesn\'t write DC4 family and given names' do
            id = NameIdentifier.new(scheme: 'ISNI', scheme_uri: URI('http://isni.org/'), value: '0000-0001-1690-159X')
            creator = Creator.new(name: 'Hedy Lamarr', given_name: 'Hedy', family_name: 'Lamarr', identifier: id, affiliations: ['United Artists', 'Metro-Goldwyn-Mayer'])
            expected_xml = '<creator>
                              <creatorName>Hedy Lamarr</creatorName>
                              <nameIdentifier schemeURI="http://isni.org/" nameIdentifierScheme="ISNI">0000-0001-1690-159X</nameIdentifier>
                              <affiliation>United Artists</affiliation>
                              <affiliation>Metro-Goldwyn-Mayer</affiliation>
                            </creator>'
            expect(creator.save_to_xml(mapping: :datacite_3)).to be_xml(expected_xml)
          end
        end

        describe 'DC4 mapping' do
          it 'reads DC4 family and given names' do
            xml = '<creator>
                     <creatorName>Hedy Lamarr</creatorName>
                     <givenName>Hedy</givenName>
                     <familyName>Lamarr</familyName>
                     <nameIdentifier schemeURI="http://isni.org/" nameIdentifierScheme="ISNI">0000-0001-1690-159X</nameIdentifier>
                     <affiliation>United Artists</affiliation>
                     <affiliation>Metro-Goldwyn-Mayer</affiliation>
                   </creator>'
            creator = Creator.parse_xml(xml)
            expect(creator.given_name).to eq('Hedy')
            expect(creator.family_name).to eq('Lamarr')
          end
          it 'writes DC4 family and given names' do
            expected_xml = '<creator>
                              <creatorName>Hedy Lamarr</creatorName>
                              <givenName>Hedy</givenName>
                              <familyName>Lamarr</familyName>
                              <nameIdentifier schemeURI="http://isni.org/" nameIdentifierScheme="ISNI">0000-0001-1690-159X</nameIdentifier>
                              <affiliation>United Artists</affiliation>
                              <affiliation>Metro-Goldwyn-Mayer</affiliation>
                            </creator>'
            id = NameIdentifier.new(scheme: 'ISNI', scheme_uri: URI('http://isni.org/'), value: '0000-0001-1690-159X')
            creator = Creator.new(name: 'Hedy Lamarr', given_name: 'Hedy', family_name: 'Lamarr', identifier: id, affiliations: ['United Artists', 'Metro-Goldwyn-Mayer'])
            expect(creator.save_to_xml).to be_xml(expected_xml)
          end
        end
      end
    end
  end
end
