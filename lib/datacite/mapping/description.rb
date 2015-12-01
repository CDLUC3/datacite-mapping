require 'xml/mapping_extensions'

module Datacite
  module Mapping

    class DescriptionType < TypesafeEnum::Base
      new :ABSTRACT, 'Abstract'
      new :METHODS, 'Methods'
      new :SERIES_INFORMATION, 'SeriesInformation'
      new :TABLE_OF_CONTENTS, 'TableOfContents'
      new :OTHER, 'Other'
    end

    class Description
      include XML::Mapping

      typesafe_enum_node :type, '@descriptionType'

    end
  end
end
