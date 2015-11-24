require 'xml/mapping_extensions'

module Datacite
  module Mapping

    class ResourceTypeGeneral < TypesafeEnum::Base
      new :AUDIOVISUAL, 'Audiovisual'
      new :COLLECTION, 'Collection'
      new :DATASET, 'Dataset'
      new :EVENT, 'Event'
      new :IMAGE, 'Image'
      new :INTERACTIVE_RESOURCE, 'InteractiveResource'
      new :MODEL, 'Model'
      new :PHYSICAL_OBJECT, 'PhysicalObject'
      new :SERVICE, 'Service'
      new :SOFTWARE, 'Software'
      new :SOUND, 'Sound'
      new :TEXT, 'Text'
      new :WORKFLOW, 'Workflow'
      new :OTHER, 'Other'
    end

    class ResourceType
      include XML::Mapping

      root_element_name 'resourceType'

      typesafe_enum_node :_resource_type_general, '@resourceTypeGeneral', class: ResourceTypeGeneral
      text_node :_value, 'text()'

      def initialize(resource_type_general:, value:)
        self.resource_type_general = resource_type_general
        self.value = value
      end

      def resource_type_general
        _resource_type_general
      end

      def resource_type_general=(val)
        fail ArgumentError, 'No general resource type provided' unless val
        self._resource_type_general = val
      end

      def value
        _value
      end

      def value=(val)
        fail ArgumentError, 'No general resource type provided' unless val
        self._value = val
      end
    end
  end
end
