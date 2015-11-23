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
      end

      describe '#load_from_xml' do
        it 'parses XML' do
          xml_text = '<creator>
                        <creatorName>Hedy Lamarr</creatorName>
                        <nameIdentifier schemeURI="http://isni.org/" nameIdentifierScheme="ISNI">0000-0001-1690-159X</nameIdentifier>
                        <affiliation>United Artists</affiliation>
                        <affiliation>Metro-Goldwyn-Mayer</affiliation>
                      </creator>'
          xml = REXML::Document.new(xml_text).root
          creator = Creator.load_from_xml(xml)
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
          xml = REXML::Document.new(xml_text).root
          creator = Creator.load_from_xml(xml)
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
    end

    describe Creators do
      it 'requires at least one creator'
      it 'round-trips to xml' do
        xml_text = '<creators>
                      <creator>
                        <creatorName>Hedy Lamarr</creatorName>
                        <nameIdentifier schemeURI="http://isni.org/" nameIdentifierScheme="ISNI">0000-0001-1690-159X</nameIdentifier>
                        <affiliation>United Artists</affiliation>
                        <affiliation>Metro-Goldwyn-Mayer</affiliation>
                      </creator>
                      <creator>
                        <creatorName>Hershlag, Natalie</creatorName>
                        <nameIdentifier schemeURI="http://isni.org/" nameIdentifierScheme="ISNI">0000-0001-0907-8419</nameIdentifier>
                        <affiliation>Gaumont Buena Vista International</affiliation>
                        <affiliation>20th Century Fox</affiliation>
                      </creator>
                    </creators>'
        xml = REXML::Document.new(xml_text).root
        creators = Creators.load_from_xml(xml)
        expect(creators.save_to_xml).to be_xml(xml_text)
      end
    end
  end
end
