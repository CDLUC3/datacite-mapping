require 'spec_helper'

module Datacite
  module Mapping
    describe Resource do
      describe '#save_to_xml' do
        it 'sets the namespace to http://datacite.org/schema/kernel-3'
        it "doesn't clobber the namespace on the title xml:lang attribute"
      end

      describe 'creators' do
        it 'returns the creator list'
        it 'returns an editable list'
      end

      describe 'creators=' do
        it 'overwrites the creator list'
      end

      describe 'titles' do
        it 'returns the title list'
        it 'returns an editable list'
      end

      describe 'titles=' do
        it 'overwrites the title list'
      end
    end
  end
end
