require 'spec_helper'

module Datacite
  module Mapping
    describe Resource do
      describe '#save_to_xml' do
        it 'sets the namespace to http://datacite.org/schema/kernel-3'
        it "doesn't clobber the namespace on the various xml:lang attributes"
      end

      describe 'identifier' do
        it 'returns the identifier'
      end

      describe 'identifier=' do
        it 'sets the identifier'
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

      describe 'publisher' do
        it 'returns the publisher'
      end

      describe 'publisher=' do
        it 'sets the publisher'
      end

      describe 'publication_year' do
        it 'returns the publication year'
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
      end
    end
  end
end
