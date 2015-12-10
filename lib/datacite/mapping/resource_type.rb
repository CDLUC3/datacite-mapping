require 'xml/mapping_extensions'

module Datacite
  module Mapping

    # Controlled vocabulary of general resource types.
    class ResourceTypeGeneral < TypesafeEnum::Base
      # @!parse AUDIOVISUAL = Audiovisual
      new :AUDIOVISUAL, 'Audiovisual'

      # @!parse COLLECTION = Collection
      new :COLLECTION, 'Collection'

      # @!parse DATASET = Dataset
      new :DATASET, 'Dataset'

      # @!parse EVENT = Event
      new :EVENT, 'Event'

      # @!parse IMAGE = Image
      new :IMAGE, 'Image'

      # @!parse INTERACTIVE_RESOURCE = InteractiveResource
      new :INTERACTIVE_RESOURCE, 'InteractiveResource'

      # @!parse MODEL = Model
      new :MODEL, 'Model'

      # @!parse PHYSICAL_OBJECT = PhysicalObject
      new :PHYSICAL_OBJECT, 'PhysicalObject'

      # @!parse SERVICE = Service
      new :SERVICE, 'Service'

      # @!parse SOFTWARE = Software
      new :SOFTWARE, 'Software'

      # @!parse SOUND = Sound
      new :SOUND, 'Sound'

      # @!parse TEXT = Text
      new :TEXT, 'Text'

      # @!parse WORKFLOW = Workflow
      new :WORKFLOW, 'Workflow'

      # @!parse OTHER = Other
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
