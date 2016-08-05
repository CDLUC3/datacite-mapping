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
