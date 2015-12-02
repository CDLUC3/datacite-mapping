require 'spec_helper'

module Datacite
  module Mapping
    describe GeoLocationPoint do
      describe '#initialize' do
        it 'accepts a lat/long pair' do
          point = GeoLocationPoint.new(47.61, -122.33)
          expect(point.latitude).to eq(47.61)
          expect(point.longitude).to eq(-122.33)
        end

        it 'accepts :latitude and :longitude' do
          point = GeoLocationPoint.new(latitude: 47.61, longitude: -122.33)
          expect(point.latitude).to eq(47.61)
          expect(point.longitude).to eq(-122.33)
        end

        it 'requires both latitude and longitude' do
          expect { GeoLocationPoint.new(47.61) }.to raise_error(ArgumentError)
          expect { GeoLocationPoint.new(latitude: 47.61) }.to raise_error(ArgumentError)
          expect { GeoLocationPoint.new(longitude: -122.33) }.to raise_error(ArgumentError)
        end

        it 'rejects extra array arguments' do
          expect { GeoLocationPoint.new(47.61, -122.33, -70.67) }.to raise_error(ArgumentError)
        end

        it 'rejects extra hash arguments' do
          expect { GeoLocationPoint.new(latitude: 47.61, longitude: -122.33, south_latitude: -70.67) }.to raise_error(ArgumentError)
        end

        it 'rejects bad values' do
          expect { GeoLocationPoint.new(91, -122.33) }.to raise_error(ArgumentError)
          expect { GeoLocationPoint.new(-91, -122.33) }.to raise_error(ArgumentError)
          expect { GeoLocationPoint.new(47.61, 181) }.to raise_error(ArgumentError)
          expect { GeoLocationPoint.new(47.61, -181) }.to raise_error(ArgumentError)
          expect { GeoLocationPoint.new(latitude: 91, longitude: -122.33) }.to raise_error(ArgumentError)
          expect { GeoLocationPoint.new(latitude: -91, longitude: -122.33) }.to raise_error(ArgumentError)
          expect { GeoLocationPoint.new(latitude: 47.61, longitude: 181) }.to raise_error(ArgumentError)
          expect { GeoLocationPoint.new(latitude: 47.61, longitude: -181) }.to raise_error(ArgumentError)
        end
      end

      describe '#latitude=' do
        it 'sets the latitude' do
          point = GeoLocationPoint.allocate
          point.latitude = 47.61
          expect(point.latitude).to eq(47.61)
        end
        it 'requires a value' do
          point = GeoLocationPoint.allocate
          expect { point.latitude = nil }.to raise_error(ArgumentError)
        end
        it 'rejects bad values' do
          point = GeoLocationPoint.allocate
          expect { point.latitude = 91 }.to raise_error(ArgumentError)
          expect { point.latitude = -91 }.to raise_error(ArgumentError)
        end
      end

      describe '#longitude=' do
        it 'sets the longitude' do
          point = GeoLocationPoint.allocate
          point.longitude = 47.61
          expect(point.longitude).to eq(47.61)
        end
        it 'requires a value' do
          point = GeoLocationPoint.allocate
          expect { point.longitude = nil }.to raise_error(ArgumentError)
        end
        it 'rejects bad values' do
          point = GeoLocationPoint.allocate
          expect { point.longitude = 181 }.to raise_error(ArgumentError)
          expect { point.longitude = -181 }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
