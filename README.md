# datacite-mapping

[![Build Status](https://travis-ci.org/CDLUC3/datacite-mapping.png?branch=master)](https://travis-ci.org/CDLUC3/datacite-mapping)
[![Code Climate](https://codeclimate.com/github/CDLUC3/datacite-mapping.png)](https://codeclimate.com/github/CDLUC3/datacite-mapping)
[![Inline docs](http://inch-ci.org/github/CDLUC3/datacite-mapping.png)](http://inch-ci.org/github/CDLUC3/datacite-mapping)
[![Gem Version](https://img.shields.io/gem/v/datacite-mapping.svg)](https://github.com/CDLUC3/datacite-mapping/releases)

A library for mapping [DataCite XML](http://schema.datacite.org/meta/kernel-4/) to Ruby objects,
based on [xml-mapping](http://multi-io.github.io/xml-mapping/) and
[xml-mapping_extensions](https://github.com/dmolesUC3/xml-mapping_extensions).
Full API documentation on [RubyDoc.info](http://www.rubydoc.info/github/CDLUC3/datacite-mapping/master/frames).

Supports [Datacite 4.0](https://schema.labs.datacite.org/meta/kernel-4.0/); backward-compatible with 
[Datacite 3.1](https://schema.labs.datacite.org/meta/kernel-3/).

## Usage

The core of the Datacite::Mapping library is the `Resource` class, corresponding to the root `<resource/>` element
in a Datacite document.

### Reading

To create a `Resource` object from XML file, use `Resource.parse_xml` or `Resource.load_from_file`,
depending on the data source:

| XML source        | Method to use             |
| ----------------- | ------------------------- |
| file path         | `Resource.load_from_file` |
| `String`          | `Resource.parse_xml`      |
| `IO`              | `Resource.parse_xml`      |
| `REXML::Document` | `Resource.parse_xml`      |
| `REXML::Element`  | `Resource.parse_xml`      |

Example:

```ruby
require 'datacite/mapping'
include Datacite::Mapping

resource = Resource.load_from_file('datacite-example-full-v4.0.xml')
# => #<Datacite::Mapping::Resource:0x007f97689e87a0 …

abstract = resource.descriptions.find { |d| d.type = DescriptionType::ABSTRACT }
# => #<Datacite::Mapping::Description:0x007f976aafa330 …
abstract.value
# => "XML example of all DataCite Metadata Schema v4.0 properties."
```

Note that Datacite::Mapping uses the `TypesafeEnum` gem to represent controlled vocabularies such
as [ResourceTypeGeneral](http://www.rubydoc.info/github/CDLUC3/datacite-mapping/master/Datacite/Mapping/ResourceTypeGeneral)
and [DescriptionType](http://www.rubydoc.info/github/CDLUC3/datacite-mapping/master/Datacite/Mapping/DescriptionType).

### Writing

In general, a `Resource` object must be provided with all required attributes on initialization.

```ruby
resource = Resource.new(
  identifier: Identifier.new(value: '10.5555/12345678'),
  creators: [
    Creator.new(
      name: 'Josiah Carberry',
      identifier: NameIdentifier.new(
        scheme: 'ORCID', 
        scheme_uri: URI('http://orcid.org/'), 
        value: '0000-0002-1825-0097'
      ),
      affiliations: [
        'Department of Psychoceramics, Brown University'
      ]
    )
  ],
  titles: [
    Title.new(value: 'Toward a Unified Theory of High-Energy Metaphysics: Silly String Theory')
  ],
  publisher: 'Journal of Psychoceramics',
  publication_year: 2008
)
#  => #<Datacite::Mapping::Resource:0x007f9768958fb0 …
```

To create XML from a `Resource` object, use `Resource.write_xml`, `Resource.save_to_file`, or
`Resource.save_to_xml`, depending on the destination:

| XML destination   | Method to use           |
| ----------------- | ----------------------- |
| XML string        | `Resource.write_xml`    |
| file path         | `Resource.save_to_file` |
| `REXML::Element`  | `Resource.save_xml`     |

```ruby
resource.write_xml
#  => "<resource xsi:schemaLocation='http://datacite.org/schema/kernel-4 …
```

#### Namespace prefix

To set a prefix for the Datacite namespace, use `Resource.namespace_prefix=`:

```ruby
resource.namespace_prefix = 'dcs'
resource.write_xml
#  => "<dcs:resource xmlns:dcs='http://datacite.org/schema/kernel-4' …
```

### Datacite 3 compatibility

In general, Datacite::Mapping is lax on read, accepting either Datacite 3 or Datacite 4 or a mix,
and (mostly for historical reasons involving bad data its authors needed to parse) allowing some 
deviations from the schema. By default, it writes Datacite 4, but can write Datacite 3 by passing
an optional argument to any of the writer methods:

```ruby
resource.write_xml(mapping: :datacite_3) # note schema URL below
# => "<resource xsi:schemaLocation='http://datacite.org/schema/kernel-3
```

When using the `:datacite_3` mapping, the Datacite 4 `<geoLocationPolygon/>` and `<fundingReference/>` 
elements, which are not supported in Datacite 3, will be dropped, with a warning. Any 
`<relatedIdentifier/>` elements of type [IGSN](http://igsn.github.io/overview/) will be converted 
to Handle identifiers with prefix 10273 (the prefix of the IGSN resolver).

## Contributing

Datacite::Mapping is released under an [MIT license](LICENSE.md). When submitting a pull request,
please make sure the Rubocop style checks pass, as well as making sure unit tests pass with 100% 
coverage; you can check these individually with `bundle exec rubocop` and `bundle exec rake:coverage`,
or run the default rake task which includes both, `bundle exec rake`.



