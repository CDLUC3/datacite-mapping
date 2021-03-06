# frozen_string_literal: true

require 'spec_helper'

module Datacite
  module Mapping
    describe Subject do
      describe '#initialize' do
        it 'sets the value' do
          value = 'Mammals--Embryology'
          subject = Subject.new(value: value, language: 'en-us')
          expect(subject.value).to eq(value)
        end

        it 'sets the language' do
          lang = 'en-us'
          subject = Subject.new(value: 'Mammals--Embryology', language: lang)
          expect(subject.language).to eq(lang)
        end

        it 'sets the scheme' do
          scheme = 'LCSH'
          subject = Subject.new(value: 'Mammals--Embryology', language: 'en-us', scheme: scheme)
          expect(subject.scheme).to eq(scheme)
        end

        it 'sets the schemeURI' do
          scheme_uri = URI('http://id.loc.gov/authorities/subjects')
          subject = Subject.new(value: 'Mammals--Embryology', language: 'en-us', scheme: 'LCSH', scheme_uri: scheme_uri)
          expect(subject.scheme_uri).to eq(scheme_uri)
        end

        it 'defaults to a nil scheme' do
          subject = Subject.new(value: 'Mammals--Embryology', language: 'en-us')
          expect(subject.scheme).to be_nil
        end

        it 'defaults to a nil schemeURI' do
          subject = Subject.new(value: 'Mammals--Embryology', language: 'en-us')
          expect(subject.scheme_uri).to be_nil
        end

        it 'defaults language to nil' do
          subject = Subject.new(value: 'Mammals--Embryology')
          expect(subject.language).to be_nil
        end

        it 'strips whitespace' do
          subject = Subject.new(value: '
            Mammals--Embryology
          ', language: 'en-us')
          expect(subject.value).to eq('Mammals--Embryology')
        end
      end

      describe 'lang=' do
        it 'sets the language' do
          subject = Subject.new(value: 'Mammals--Embryology', language: 'en')
          new_lang = 'en-us'
          subject.language = new_lang
          expect(subject.language).to eq(new_lang)
        end

        it 'allows nil' do
          subject = Subject.new(value: 'Mammals--Embryology', language: 'en-us')
          subject.language = nil
          expect(subject.language).to be_nil
        end
      end

      describe '#load_from_xml' do
        it 'parses XML' do
          xml_text = '<subject xml:lang="en-us" schemeURI="http://id.loc.gov/authorities/subjects" subjectScheme="LCSH">Mammals--Embryology</subject>'
          subject = Subject.parse_xml(xml_text)

          value = 'Mammals--Embryology'
          lang = 'en-us'
          scheme = 'LCSH'
          scheme_uri = URI('http://id.loc.gov/authorities/subjects')

          expect(subject.value).to eq(value)
          expect(subject.language).to eq(lang)
          expect(subject.scheme).to eq(scheme)
          expect(subject.scheme_uri).to eq(scheme_uri)
        end

        it 'treats missing language as nil' do
          xml_text = '<subject schemeURI="http://id.loc.gov/authorities/subjects" subjectScheme="LCSH">Mammals--Embryology</subject>'
          subject = Subject.parse_xml(xml_text)
          expect(subject.language).to be_nil
        end
      end

      describe '#save_to_xml' do
        it 'writes XML' do
          value = 'Mammals--Embryology'
          lang = 'en-us'
          scheme = 'LCSH'
          scheme_uri = URI('http://id.loc.gov/authorities/subjects')

          subject = Subject.new(
            language: lang,
            scheme: scheme,
            scheme_uri: scheme_uri,
            value: value
          )

          expected_xml = '<subject xml:lang="en-us" schemeURI="http://id.loc.gov/authorities/subjects" subjectScheme="LCSH">Mammals--Embryology</subject>'
          expect(subject.save_to_xml).to be_xml(expected_xml)
        end
      end
    end
  end
end
