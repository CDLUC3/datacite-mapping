#!/usr/bin/env ruby
# frozen_string_literal: true

require 'datacite/mapping'
include Datacite::Mapping

xml_text = '<?xml version="1.0" encoding="UTF-8"?>
            <resource xsi:schemaLocation="http://datacite.org/schema/kernel-3 http://schema.datacite.org/meta/kernel-3/metadata.xsd" xmlns="http://datacite.org/schema/kernel-3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
              <identifier identifierType="DOI">10.5072/geoPointExample</identifier>
              <creators>
                <creator>
                  <creatorName>Schumann, Kai</creatorName>
                </creator>
                <creator>
                  <creatorName>Völker, David</creatorName>
                </creator>
                <creator>
                  <creatorName>Weinrebe, Wilhelm Reiber</creatorName>
                </creator>
              </creators>
              <titles>
                <title>Gridded results of swath bathymetric mapping of Disko Bay, Western Greenland, 2007-2008</title>
              </titles>
              <publisher>PANGAEA - Data Publisher for Earth &amp; Environmental Science</publisher>
              <publicationYear>2011</publicationYear>
              <subjects>
                <subject subjectScheme="DDC">551 Geology, hydrology, meteorology</subject>
              </subjects>
              <contributors>
                <contributor contributorType="HostingInstitution">
                  <contributorName>IFM-GEOMAR Leibniz-Institute of Marine Sciences, Kiel University</contributorName>
                </contributor>
              </contributors>
              <language>en</language>
              <resourceType resourceTypeGeneral="Dataset"/>
              <relatedIdentifiers>
                <relatedIdentifier relatedIdentifierType="DOI" relationType="Continues">10.5072/timeSeries</relatedIdentifier>
              </relatedIdentifiers>
              <sizes>
                <size>4 datasets</size>
              </sizes>
              <formats>
                <format>application/zip</format>
              </formats>
              <rightsList><rights rightsURI="http://creativecommons.org/licenses/by/3.0/deed">Creative Commons Attribution 3.0 Unported</rights></rightsList>
              <descriptions>
                <description descriptionType="Abstract">A ship-based acoustic mapping campaign was conducted at the exit of Ilulissat Ice Fjord and in the sedimentary basin of Disko Bay to the west of the fjord mouth. Submarine landscape and sediment distribution patterns are interpreted in terms of glaciomarine facies types that are related to variations in the past position of the glacier front. In particular, asymmetric ridges that form a curved entity and a large sill at the fjord mouth may represent moraines that depict at least two relatively stable positions of the ice front in the Disko Bay and at the fjord mouth. In this respect, Ilulissat Glacier shows prominent differences to the East Greenland Kangerlussuaq Glacier which is comparable in present size and present role for the ice discharge from the inland ice sheet. Two linear clusters of pockmarks in the center of the sedimentary basin seem to be linked to ongoing methane release due to dissociation of gas hydrates, a process fueled by climate warming in the Arctic realm.
                </description>
              </descriptions>
              <geoLocations>
                <geoLocation>
                  <geoLocationPoint>-52.000000 69.000000 </geoLocationPoint>
                  <geoLocationPlace>Disko Bay</geoLocationPlace>
                </geoLocation>
              </geoLocations>
            </resource>'

resource = Resource.parse_xml(xml_text)

creators = resource.creators
citation = ''
citation << creators.map(&:name).join('; ')
citation << ' '
citation << "(#{resource.publication_year})"
citation << ': '
title = resource.titles[0].value
citation << title
citation << (title.end_with?('.') ? ' ' : '. ')
citation << resource.publisher

puts("Citation: #{citation}")

abstract = resource.descriptions.find { |d| d.type = DescriptionType::ABSTRACT }
puts("Abstract: #{abstract.value}")
