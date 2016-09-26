require 'logger'
require 'rexml/formatters/transitive' # unaccountably, xml/mapping doesn't do this
require 'xml/mapping_extensions'

# Module for working with the [DataCite metadata schema](https://schema.datacite.org/)
module Datacite
  # Maps DataCite XML to Ruby objects
  module Mapping

    DATACITE_3_NAMESPACE = XML::MappingExtensions::Namespace.new(
      uri: 'http://datacite.org/schema/kernel-3',
      schema_location: 'http://schema.datacite.org/meta/kernel-3/metadata.xsd'
    )

    DATACITE_4_NAMESPACE = XML::MappingExtensions::Namespace.new(
      uri: 'http://datacite.org/schema/kernel-4',
      schema_location: 'http://schema.datacite.org/meta/kernel-4/metadata.xsd'
    )

    Dir.glob(File.expand_path('../mapping/*.rb', __FILE__)).sort.each(&method(:require))

  end
end
