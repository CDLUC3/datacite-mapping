## 0.1.8 (Next)

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
