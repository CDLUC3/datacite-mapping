require 'spec_helper'

module Datacite
  module Mapping

    describe GeoLocation do
      describe '#initialize' do
        it 'accepts a point'
        it 'accepts a box'
        it 'accepts a place'
        it 'allows an empty location'
      end

      describe '#point=' do
        it 'sets the point'
        it 'accepts nil'
      end

      describe '#box=' do
        it 'sets the point'
        it 'accepts nil'
      end

      describe '#place=' do
        it 'sets the place'
        it 'accepts nil'
      end
    end
  end
end
