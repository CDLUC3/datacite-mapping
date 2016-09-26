require 'spec_helper'

module Datacite
  module Mapping
    describe GeoLocationPolygon do
      describe '#==' do
        it 'reports equal values as equal' do
          polygon1 = GeoLocationPolygon.new(points: [
            GeoLocationPoint.new(-33.45, -122.33),
            GeoLocationPoint.new(33.45, -122.33),
            GeoLocationPoint.new(33.45, 122.33),
            GeoLocationPoint.new(-33.45, -122.33)
          ])
          polygon2 = GeoLocationPolygon.new(points: [
            GeoLocationPoint.new(-33.45, -122.33),
            GeoLocationPoint.new(33.45, -122.33),
            GeoLocationPoint.new(33.45, 122.33),
            GeoLocationPoint.new(-33.45, -122.33)
          ])
          expect(polygon1).to eq(polygon2)
          expect(polygon1.hash).to eq(polygon2.hash)
          expect(polygon2).to eq(polygon1)
          expect(polygon2.hash).to eq(polygon1.hash)
        end

        it 'reports unequal values as unequal' do
          polygon1 = GeoLocationPolygon.new(points: [
            GeoLocationPoint.new(-33.45, -122.33),
            GeoLocationPoint.new(33.45, -122.33),
            GeoLocationPoint.new(33.45, 122.33),
            GeoLocationPoint.new(-33.45, -122.33)
          ])
          polygon2 = GeoLocationPolygon.new(points: [
            GeoLocationPoint.new(33.45, 122.33),
            GeoLocationPoint.new(-33.45, 122.33),
            GeoLocationPoint.new(-33.45, -122.33),
            GeoLocationPoint.new(33.45, 122.33)
          ])
          expect(polygon1).not_to eq(polygon2)
          expect(polygon1.hash).not_to eq(polygon2.hash)
          expect(polygon2).not_to eq(polygon1)
          expect(polygon2.hash).not_to eq(polygon1.hash)
        end
      end
    end
  end
end
