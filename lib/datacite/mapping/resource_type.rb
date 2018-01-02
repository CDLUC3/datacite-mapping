# frozen_string_literal: true

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

      # Initializes a new {ResourceType}
      # @param resource_type_general [ResourceTypeGeneral] the general resource type
      # @param value [String] additional free text description of the resource type.
      def initialize(resource_type_general:, value: nil)
        self.resource_type_general = resource_type_general
        self.value = value
      end

      def resource_type_general=(val)
        raise ArgumentError, 'General resource type cannot be nil' unless val
        @resource_type_general = val
      end

      root_element_name 'resourceType'

      # @!attribute [rw] resource_type_general
      #    @return [ResourceTypeGeneral] the general resource type
      typesafe_enum_node :resource_type_general, '@resourceTypeGeneral', class: ResourceTypeGeneral

      # @!attribute [rw] value
      #    @return [String] additional free text description of the resource type. Optional.
      text_node :value, 'text()', default_value: nil
    end
  end
end
