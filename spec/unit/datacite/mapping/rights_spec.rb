require 'spec_helper'

module Datacite
  module Mapping
    describe Rights do
      describe '#initialize' do
        it 'sets the value' do
          rights = Rights.new(value: 'CC0 1.0 Universal')
          expect(rights.value).to eq('CC0 1.0 Universal')
        end
        it 'sets the URI' do
          rights = Rights.new(value: 'CC0 1.0 Universal', uri: URI('http://creativecommons.org/publicdomain/zero/1.0/'))
          expect(rights.uri).to eq(URI('http://creativecommons.org/publicdomain/zero/1.0/'))
        end
        it 'requires a value' do
          expect { Rights.new(uri: URI('http://creativecommons.org/publicdomain/zero/1.0/')) }.to raise_error(ArgumentError)
        end
      end

      describe '#value=' do
        it 'sets the value' do
          rights = Rights.allocate
          rights.value = 'CC0 1.0 Universal'
          expect(rights.value).to eq('CC0 1.0 Universal')
        end
        it 'requires a value' do
          rights = Rights.new(value: 'CC0 1.0 Universal')
          expect { rights.value = nil }.to raise_error(ArgumentError)
          expect(rights.value).to eq('CC0 1.0 Universal')
        end
        it 'requires a non-empty value' do
          rights = Rights.new(value: 'CC0 1.0 Universal')
          expect { rights.value = '' }.to raise_error(ArgumentError)
          expect(rights.value).to eq('CC0 1.0 Universal')
        end
      end

      describe '#uri=' do
        it 'sets the URI' do
          rights = Rights.allocate
          rights.uri = URI('http://creativecommons.org/publicdomain/zero/1.0/')
          expect(rights.uri).to eq(URI('http://creativecommons.org/publicdomain/zero/1.0/'))
        end
        it 'allows a nil URI' do
          rights = Rights.new(value: 'CC0 1.0 Universal', uri: URI('http://creativecommons.org/publicdomain/zero/1.0/'))
          rights.uri = nil
          expect(rights.uri).to be_nil
        end
      end

      describe '#load_from_xml' do
        it 'reads XML' do
          xml_text = '<rights rightsURI="http://creativecommons.org/publicdomain/zero/1.0/">CC0 1.0 Universal</rights>'
          rights = Rights.parse_xml(xml_text)
          expect(rights.value).to eq('CC0 1.0 Universal')
          expect(rights.uri).to eq(URI('http://creativecommons.org/publicdomain/zero/1.0/'))
        end
        it 'trims the value' do
          xml_text = '<rights>
                        CC0 1.0 Universal
                      </rights>'
          rights = Rights.parse_xml(xml_text)
          expect(rights.value).to eq('CC0 1.0 Universal')
        end
      end

      describe '#save_to_xml' do
        it 'writes XML' do
          rights = Rights.new(value: 'CC0 1.0 Universal', uri: URI('http://creativecommons.org/publicdomain/zero/1.0/'))
          expected_xml = '<rights rightsURI="http://creativecommons.org/publicdomain/zero/1.0/">CC0 1.0 Universal</rights>'
          expect(rights.save_to_xml).to be_xml(expected_xml)
        end
      end
    end
  end
end
