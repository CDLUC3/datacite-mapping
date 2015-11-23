require 'spec_helper'

module Datacite
  module Mapping
    describe Resource do

      describe '#initialize' do
        it 'requires an identifier'
        it 'requires creators'
        it 'requires titles'
        it 'requires a publisher'
        it 'requires a publicationYear'
        it 'allows subjects'
        it 'allows dates'
        it 'allows a language'
        it 'allows alternate identifiers'
        it 'allows related identifiers'
        it 'allows sizes'
        it 'allows formats'
        it 'allows a version'
        it 'allows rights'
      end

      describe '#save_to_xml' do
        it 'sets the namespace to http://datacite.org/schema/kernel-3'
        it "doesn't clobber the namespace on the various xml:lang attributes"
      end

      describe 'identifier' do
        it 'returns the identifier'
      end

      describe 'identifier=' do
        it 'sets the identifier'
        it 'rejects nil'
      end

      describe 'creators' do
        it 'returns the creator list'
        it 'returns an editable list'
      end

      describe 'creators=' do
        it 'overwrites the creator list'
        it 'requires at least one creator'
      end

      describe 'titles' do
        it 'returns the title list'
        it 'returns an editable list'
      end

      describe 'titles=' do
        it 'overwrites the title list'
        it 'requires at least one title'
      end

      describe 'publisher' do
        it 'returns the publisher'
      end

      describe 'publisher=' do
        it 'sets the publisher'
        it 'rejects nil'
      end

      describe 'publication_year' do
        it 'returns the publication year'
        it 'rejects nil'
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
        it 'accepts an empty list'
      end

      describe 'dates' do
        it 'returns the date list'
        it 'returns an editable list'
      end

      describe 'dates=' do
        it 'overwrites the date list'
        it 'accepts an empty list'
      end

      describe 'language' do
        it 'returns the language'
      end

      describe 'language=' do
        it 'sets the languge'
        it 'accepts nil'
      end

      describe 'alternate_identifiers' do
        it 'returns the alternate identifier list'
        it 'returns an editable list'
      end

      describe 'alternate_identifiers=' do
        it 'overwrites the alternate identifier list'
        it 'accepts an empty list'
      end

      describe 'related_identifiers' do
        it 'returns the related identifier list'
        it 'returns an editable list'
      end

      describe 'related_identifiers=' do
        it 'overwrites the related identifier list'
        it 'accepts an empty list'
      end

      describe 'sizes' do
        it 'returns the size list'
        it 'returns an editable list'
      end

      describe 'sizes=' do
        it 'overwrites the size list'
        it 'accepts an empty list'
      end

      describe 'formats' do
        it 'returns the size list'
        it 'returns an editable list'
      end

      describe 'formats=' do
        it 'overwrites the size list'
        it 'accepts an empty list'
      end

      describe 'version' do
        it 'returns the version'
      end

      describe 'version=' do
        it 'sets the languge'
        it 'accepts nil'
      end

      describe 'rights' do
        it 'returns the rights list'
        it 'returns an editable list'
      end

      describe 'rights=' do
        it 'overwrites the rights list'
        it 'accepts an empty list'
      end

      describe 'descriptions' do
        it 'returns the description list'
        it 'returns an editable list'
      end

      describe 'descriptions=' do
        it 'overwrites the description list'
        it 'accepts an empty list'
      end

      describe 'geo_locations' do
        it 'returns the geolocation list'
        it 'returns an editable list'
      end

      describe 'geo_locations=' do
        it 'overwrites the geolocation list'
        it 'accepts an empty list'
      end
    end
  end
end
