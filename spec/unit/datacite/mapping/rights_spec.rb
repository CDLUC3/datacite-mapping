require 'spec_helper'

module Datacite
  module Mapping
    describe Size do
      describe '#initialize' do
        it 'sets the value'
        it 'requires a value'
        it 'sets the URI'
        it 'allows a null URI'
      end

      describe '#value=' do
        it 'sets the value'
        it 'requires a value'
      end

      describe '#uri=' do
        it 'sets the URI'
        it 'allows a null URI'
      end

      describe '#load_from_xml' do
        it 'reads XML'
      end

      describe '#save_to_xml' do
        it 'writes XML'
      end
    end
  end
end
