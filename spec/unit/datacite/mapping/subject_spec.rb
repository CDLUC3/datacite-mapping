require 'spec_helper'

module Datacite
  module Mapping
    describe Subject do
      describe '#initialize' do
        it 'sets the value' do
          value = 'Mammals--Embryology'
          subject = Subject.new(value: value, lang: 'en-us')
          expect(subject.value).to eq(value)
        end

        it 'sets the language' do
          lang = 'en-us'
          subject = Subject.new(value: 'Mammals--Embryology', lang: lang)
          expect(subject.lang).to eq(lang)
        end

        it 'sets the scheme' do
          scheme = 'LCSH'
          subject = Subject.new(value: 'Mammals--Embryology', lang: 'en-us', scheme: scheme)
          expect(subject.scheme).to eq(scheme)
        end

        it 'sets the schemeURI' do
          scheme_uri = URI('http://id.loc.gov/authorities/subjects')
          subject = Subject.new(value: 'Mammals--Embryology', lang: 'en-us', scheme: 'LCSH', scheme_uri: scheme_uri)
          expect(subject.scheme_uri).to eq(scheme_uri)
        end

        it 'defaults to a nil scheme' do
          subject = Subject.new(value: 'Mammals--Embryology', lang: 'en-us')
          expect(subject.scheme).to be_nil
        end

        it 'defaults to a nil schemeURI' do
          subject = Subject.new(value: 'Mammals--Embryology', lang: 'en-us')
          expect(subject.scheme_uri).to be_nil
        end

        it 'requires a language' do
          expect { Subject.new(value: 'Mammals--Embryology') }.to raise_error(ArgumentError)
        end

      end

      describe 'lang=' do
        it 'sets the language' do
          subject = Subject.new(value: 'Mammals--Embryology', lang: 'en')
          new_lang = 'en-us'
          subject.lang = new_lang
          expect(subject.lang).to eq(new_lang)
        end

        it 'requires a language' do
          subject = Subject.new(value: 'Mammals--Embryology', lang: 'en')
          expect { subject.lang = nil }.to raise_error(ArgumentError)
        end
      end

      describe '#load_from_xml' do
        it 'parses XML' do
          xml_text = '<subject xml:lang="en-us" schemeURI="http://id.loc.gov/authorities/subjects" subjectScheme="LCSH">Mammals--Embryology</subject>'
          xml = REXML::Document.new(xml_text).root
          subject = Subject.load_from_xml(xml)

          value = 'Mammals--Embryology'
          lang = 'en-us'
          scheme = 'LCSH'
          scheme_uri = URI('http://id.loc.gov/authorities/subjects')

          expect(subject.value).to eq(value)
          expect(subject.lang).to eq(lang)
          expect(subject.scheme).to eq(scheme)
          expect(subject.scheme_uri).to eq(scheme_uri)
        end

        it 'treats missing language as en' do
          xml_text = '<subject schemeURI="http://id.loc.gov/authorities/subjects" subjectScheme="LCSH">Mammals--Embryology</subject>'
          xml = REXML::Document.new(xml_text).root
          subject = Subject.load_from_xml(xml)
          expect(subject.lang).to eq('en')
        end
      end

      describe '#save_to_xml' do
        it 'writes XML' do
          value = 'Mammals--Embryology'
          lang = 'en-us'
          scheme = 'LCSH'
          scheme_uri = URI('http://id.loc.gov/authorities/subjects')

          subject = Subject.new(
            lang: lang,
            scheme: scheme,
            scheme_uri: scheme_uri,
            value: value
          )

          expected_xml = '<subject xml:lang="en-us" schemeURI="http://id.loc.gov/authorities/subjects" subjectScheme="LCSH">Mammals--Embryology</subject>'
          expect(subject.save_to_xml).to be_xml(expected_xml)
        end
      end
    end

    describe Subjects do
      it 'round-trips to XML' do
        xml_text = '<subjects>
                      <subject xml:lang="en-us" schemeURI="http://id.loc.gov/authorities/subjects" subjectScheme="LCSH">Mammals--Embryology</subject>
                      <subject xml:lang="fr" schemeURI="http://dewey.info/" subjectScheme="dewey">571.8 Croissance, développement, reproduction biologique (fécondation, sexualité)</subject>
                    </subjects>'
        xml = REXML::Document.new(xml_text).root
        subjects = Subjects.load_from_xml(xml)
        expect(subjects.save_to_xml).to be_xml(xml)
      end
    end
  end
end
