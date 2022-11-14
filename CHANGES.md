## 0.5.0 (12 November 2019)
- Update to Ruby 3.0.4
- Update to Rubocop 0.93

## 0.4.0 (12 November 2019)

- Datacite 4.3 support:
  - Added the new elements and attributes introduced in DataCite 4.1, 4.2, and 4.3.
  - Updated sample DataCite XML documents to include the new examples introduced in DataCite 4.3.
  - Reading from XML still supports any version of the DataCite schema from 3.0 through 4.3.
  - Object mapping for some items was updated to use full objects instead of simple Strings
    when the DataCite schema introduced more complicated structure. E.g., because ContributorName
    can now include a nameType and an xml:lang, the simple "name" String in the Contributor object was
    replaced with a ContributorName object, accessed through Contributor.contributor_name, while
    Contributor.name is now a convenience method that allows access to the value as a String.
- These updates to the gem are fully backwards compatible with respect to the input/output XML, but some changes in the object 
  model were required to support the more complex XML. So ruby code that worked with version 0.3.0 will require minor updates to use
  this version.

## 0.3.0 (2 January 2018)

- Update to Ruby 2.4.1
- Update to RuboCop 0.52

## 0.2.5 (10 January 2017)

- Update to Ruby 2.2.5
- Treat blank or empty award number as nil when constructing a `FundingReference`.

## 0.2.4 (8 November 2016)

- Fix issue where writing a resource in Datacite 3 would cause the Datacite 3 namespace
  to stick around, even when later writing Datacite 4.
- Remove well-intentioned but ill-advised feature that would auto-sort `<geoLocationBox/>`
  coordinates into north/south and east/west.

## 0.2.3 (5 October 2016)

- Allow empty `<identifier/>` tags on read, but not write
- Allow but ignore empty `<subject/>` and `<description/>` tags on read

## 0.2.2 (4 October 2016)

- Fixed issue where `<geoLocation>` child elements would be written in Datacite 4
  schema declaration order (place, point, box, polygon) instead of Datacite 3
  schema sequence order (point, box, place), causing `<geoLocation>` elements with
  multiple children to fail Datacite 3 schema validation.
- Allow `Resource.version` to take numeric arguments. 
- Fixed issue where `Date#<=>` would erroneously report date objects with the
  same value but differen types as equal.

## 0.2.1 (28 September 2016)

- Fixed issue where `Datacite::Mapping::Date` objects initialized with Ruby
  `Dates` or `Datetimes` couldn't be serialized to XML.

## 0.2.0 (26 September 2016)

- Datacite 4.0 support:
  - reading supports both Datacite 3 and Datacite 4
  - writing now defaults to Datacite 4
    - deprecated elements will produce a warning
  - Datacite 3 support via `mapping: :datacite_3`
    - invalid elements (`<geoLocationPolygon/>`, `<fundingReference>`)
      will be dropped, with a warning
    - [IGSN](http://igsn.github.io/overview/) identifiers will be converted to Handle identifiers
- `language` and `xml:lang` attributes no longer default to `'en'` and are 
  now fully optional.
- `Date` now properly supports [RKMS-ISO8601](http://www.ukoln.ac.uk/metadata/dcmi/collection-RKMS-ISO8601/)
  date ranges
- Remove `Datacite::Mapping.log` in favor of `warn()`
- Array fields (`subjects`, `contributors`, etc.) can no longer be set to nil; if set to 
  nil they will instead return an empty array.
- `:nonvalidating` mapping has been removed. Instead:
  - `<subject/>` and `<description/>` tags without text are ignored on read, as are `<geoLocation>`
    tags with no child elements.
  - missing `<identifiers/>` and `<identifiers/>` with missing values are ignored on read, but
    the `Resource` must be given a valid `Identifier` before writing it back out.

## 0.1.18 (unreleased)

- Datacite 4.0 support:
  - read Datacite 4.0 `<fundingReference/>` tag (introduced in 0.1.17)
  - read Datacite 4.0 `<geoLocationBox>` nodes with coordinates in child nodes
    (`<southBoundLatitude>`, `<westBoundLongitude>`, `<northBoundLatitude>`, `<eastBoundLongitude>`)
    rather than element text
  - read Datacite 4.0 `<geoLocationPoint` nodes coordinates in child nodes
    (`<pointLatitude>`, `<pointLongitude>`) rather than element text

## 0.1.17.2 (19 August 2016)

- Filter out `<subject/>` tags without values

## 0.1.17.1 (5 August 2016)

- In `Rights::CC_BY`, use "Creative Commons Attribution 4.0 International (CC BY 4.0)" 
  as value, as per [summary](https://creativecommons.org/licenses/by/4.0/), instead of 
  "Creative Commons Attribution 4.0 International (CC-BY)".

## 0.1.17 (5 August 2016)

- Added experimental support for Datacite 4.0 `<fundingReference/>` tag
- Added convenience constants `Rights::CC_ZERO` and `Rights::CC_BY` for the
  [CC0](https://creativecommons.org/publicdomain/zero/1.0/legalcode) public domain declaration
  and [CC-BY](https://creativecommons.org/licenses/by/4.0/) Creative Commons Attribution License

## 0.1.16 (14 July 2016)

- Add new `:nonvalidating` mapping for less strict parsing of problem files.
- Provide better error messages for missing identifier values.

## 0.1.15 (18 May 2016)

- Update to XML::MappingExtensions 0.4.1

## 0.1.14 (17 May 2016)

- Fix issues with XML::MappingExtensions 0.4.x

## 0.1.13 (2 May 2016)

- Update to XML::MappingExtensions 0.3.6 for improved namespace support
- Added `namespace_prefix` accessor to `Resource` to support explicit namespace prefixing
- Update to TypesafeEnum 0.1.7 for improved debug output

## 0.1.12 (28 April 2016)

- Update to XML::MappingExtensions 0.3.5

## 0.1.11 (28 April 2016)

- (withdrawn)

## 0.1.10 (25 April 2016)

- Replace all `require_relative` with absolute `require` to avoid symlink issues

## 0.1.9 (19 April 2016)

- Added convenience methods to directly access creator names and affiliations
- Added convenience methods to directly access funder attributes

## 0.1.8 (7 April 2016)

- Add convenience method `Identifier.from_doi()` to parse DOI strings in various formats (`doi:`,
  `http://dx.doi.org/`, etc.)

## 0.1.7 (28 March 2016)

- Stop having XML::Mapping generate accessors for fields that need validation (& stop using aliasing
  to layer validation on top of generated accessors)

## 0.1.6 (24 March 2016)

- Make validation method aliasing more robust against double-require problems, hopefully preventing
  `SystemStackError (stack level too deep)` on misconfigured systems

## 0.1.5 (27 Jan 2016)

- Make gemspec smart enough to handle SSH checkouts
- Update to [XML::MappingExtensions](https://github.com/dmolesUC3/xml-mapping_extensions) 0.3.4
- Update to [TypesafeEnum](https://github.com/dmolesUC3/typesafe_enum) 0.1.5

## 0.1.4 (6 Jan 2016)

- Fix issue where missing `xml:lang` attribute in `<resource>` would produce a `no value, and no default value`
  error instead of defaulting to `'en'` as documented
- Ensure that YARD formats README correctly when converting from GitHub-flavored Markdown to HTML
- Update to [XML::MappingExtensions](https://github.com/dmolesUC3/xml-mapping_extensions) 0.3.3

## 0.1.3 (18 Dec 2015)

- Update to [TypesafeEnum](https://github.com/dmolesUC3/typesafe_enum) 0.1.4

## 0.1.2 (17 Dec 2015)

- Update to [TypesafeEnum](https://github.com/dmolesUC3/typesafe_enum) 0.1.3

## 0.1.1 (14 Dec 2015)

- Update to [XML::MappingExtensions](https://github.com/dmolesUC3/xml-mapping_extensions) 0.3.2, allowing
  use of [#parse_xml](http://www.rubydoc.info/github/dmolesUC3/xml-mapping_extensions/master/XML/Mapping/ClassMethods#parse_xml-instance_method)
  and [#write_xml](http://www.rubydoc.info/github/dmolesUC3/xml-mapping_extensions/master/XML/Mapping#write_xml-instance_method)
  in examples and tests

## 0.1.0 (10 Dec 2015)

- Initial release
