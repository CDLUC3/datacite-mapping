require 'spec_helper'

module Datacite
  module Mapping

    describe Contributor do
      describe '#initialize' do
        it 'sets the contributor name' do
          contributor = Contributor.new(name: 'Hedy Lamarr', type: ContributorType::RESEARCHER)
          expect(contributor.name).to eq('Hedy Lamarr')
        end

        it 'sets the identifier' do
          id = NameIdentifier.new(scheme: 'ISNI', scheme_uri: URI('http://isni.org/'), value: '0000-0001-1690-159X')
          contributor = Contributor.new(name: 'Hedy Lamarr', identifier: id, type: ContributorType::RESEARCHER)
          expect(contributor.identifier).to eq(id)
        end

        it 'sets affiliations' do
          affiliations = ['United Artists', 'Metro-Goldwyn-Mayer']
          contributor = Contributor.new(name: 'Hedy Lamarr', affiliations: affiliations, type: ContributorType::RESEARCHER)
          expect(contributor.affiliations).to eq(affiliations)
        end

        it 'sets the contributor type' do
          ContributorType.each do |t|
            contributor = Contributor.new(name: 'Hedy Lamarr', type: t)
            expect(contributor.type).to eq(t)
          end
        end

        it 'requires a contributor name' do
          expect { Contributor.new(type: ContributorType::RESEARCHER) }.to raise_error(ArgumentError)
        end

        it 'requires a contributor type' do
          expect { Contributor.new(name: 'Hedy Lamarr') }.to raise_error(ArgumentError)
        end

        it 'defaults to a nil identifier' do
          contributor = Contributor.new(name: 'Hedy Lamarr', type: ContributorType::RESEARCHER)
          expect(contributor.identifier).to be_nil
        end

        it 'defaults to an empty affiliation array' do
          contributor = Contributor.new(name: 'Hedy Lamarr', type: ContributorType::RESEARCHER)
          expect(contributor.affiliations).to eq([])
        end

      end

      describe '#load_from_xml' do
        it 'parses XML' do
          xml_text = '<contributor contributorType="ProjectMember">
                        <contributorName>Hershlag, Natalie</contributorName>
                        <nameIdentifier schemeURI="http://isni.org/" nameIdentifierScheme="ISNI">0000-0001-0907-8419</nameIdentifier>
                        <affiliation>Gaumont Buena Vista International</affiliation>
                        <affiliation>20th Century Fox</affiliation>
                      </contributor>'
          xml = REXML::Document.new(xml_text).root
          contributor = Contributor.load_from_xml(xml)
          expect(contributor.name).to eq('Hershlag, Natalie')
          expect(contributor.affiliations).to eq(['Gaumont Buena Vista International', '20th Century Fox'])
          id = contributor.identifier
          expect(id.scheme).to eq('ISNI')
          expect(id.scheme_uri).to eq(URI('http://isni.org'))
          expect(id.value).to eq('0000-0001-0907-8419')
          expect(contributor.type).to eq(ContributorType::PROJECT_MEMBER)

        end

        it 'defaults to an empty affiliation array' do
          xml_text = '<contributor contributorType="Researcher">
                        <contributorName>Hedy Lamarr</contributorName>
                        <nameIdentifier schemeURI="http://isni.org/" nameIdentifierScheme="ISNI">0000-0001-1690-159X</nameIdentifier>
                      </contributor>'
          xml = REXML::Document.new(xml_text).root
          contributor = Contributor.load_from_xml(xml)
          expect(contributor.affiliations).to eq([])
        end
      end

      describe '#save_to_xml' do
        it 'writes XML' do
          id = NameIdentifier.new(scheme: 'ISNI', scheme_uri: URI('http://isni.org/'), value: '0000-0001-1690-159X')
          contributor = Contributor.new(name: 'Hedy Lamarr', type: ContributorType::RESEARCHER, identifier: id, affiliations: ['United Artists', 'Metro-Goldwyn-Mayer'])
          expected_xml = '<contributor contributorType="Researcher">
                            <contributorName>Hedy Lamarr</contributorName>
                            <nameIdentifier schemeURI="http://isni.org/" nameIdentifierScheme="ISNI">0000-0001-1690-159X</nameIdentifier>
                            <affiliation>United Artists</affiliation>
                            <affiliation>Metro-Goldwyn-Mayer</affiliation>
                          </contributor>'
          expect(contributor.save_to_xml).to be_xml(expected_xml)
        end
      end
    end
  end
end
