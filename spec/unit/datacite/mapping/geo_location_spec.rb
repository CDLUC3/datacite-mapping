require 'spec_helper'

module Datacite
  module Mapping

    describe GeoLocationPoint do
      describe '#initialize' do
        it 'accepts a lat/long pair'
        it 'accepts :latitude and :longitude'
        it 'requires both latitude and longitude'
        it 'rejects extra array arguments'
        it 'rejects extra hash arguments'
      end

      describe '#latitude=' do
        it 'sets the latitude'
        it 'requires a value'
      end

      describe '#longitude=' do
        it 'sets the longitude'
        it 'requires a value'
      end
    end

    describe GeoLocationBox do
      describe '#initialize' do
        it 'accepts a lat/long/lat/long quad'
        it 'accepts :south_latitude, :west_longitude, :north_latitude, :east_longitude '
        it 'requires all four coordinates'
        it 'rejects extra array arguments'
        it 'rejects extra hash arguments'
      end

      describe '#south_latitude=' do
        it 'sets the south_latitude'
        it 'requires a value'
      end

      describe '#west_longitude=' do
        it 'sets the west_longitude'
        it 'requires a value'
      end

      describe '#north_latitude=' do
        it 'sets the north_latitude'
        it 'requires a value'
      end

      describe '#east_longitude=' do
        it 'sets the east_longitude'
        it 'requires a value'
      end
    end

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
