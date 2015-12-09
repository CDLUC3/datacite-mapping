require 'xml/mapping_extensions'

module Datacite
  module Mapping

    # Controlled vocabulary of general resource types
    class ResourceTypeGeneral < TypesafeEnum::Base # TODO: list enum values in docs
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

    # The type of the resource
    class ResourceType
      include XML::Mapping

      root_element_name 'resourceType'

      # @!attribute [rw] resource_type_general
      #    @return [ResourceTypeGeneral] the general resource type
      typesafe_enum_node :resource_type_general, '@resourceTypeGeneral', class: ResourceTypeGeneral

      # @!attribute [rw] value
      #    @return [String] additional free text description of the resource type.
      text_node :value, 'text()'

      alias_method :_resource_type_general=, :resource_type_general=
      alias_method :_value=, :value=

      # Initializes a new {ResourceType}
      # @param resource_type_general [ResourceTypeGeneral] the general resource type
      # @param value [String] additional free text description of the resource type.
      def initialize(resource_type_general:, value:)
        self.resource_type_general = resource_type_general
        self.value = value
      end

      def resource_type_general=(val)
        fail ArgumentError, 'No general resource type provided' unless val
        self._resource_type_general = val
      end

      def value=(val)
        fail ArgumentError, 'No general resource type provided' unless val
        self._value = val
      end
    end
  end
end
