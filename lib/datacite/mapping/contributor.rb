require 'xml/mapping_extensions'
require_relative 'name_identifier'

module Datacite
  module Mapping

    # Controlled vocabulary of contributor types.
    class ContributorType < TypesafeEnum::Base # TODO: list enum values in docs
      new :CONTACT_PERSON, 'ContactPerson'
      new :DATA_COLLECTOR, 'DataCollector'
      new :DATA_CURATOR, 'DataCurator'
      new :DATA_MANAGER, 'DataManager'
      new :DISTRIBUTOR, 'Distributor'
      new :EDITOR, 'Editor'
      new :FUNDER, 'Funder'
      new :HOSTING_INSTITUTION, 'HostingInstitution'
      new :PRODUCER, 'Producer'
      new :PROJECT_LEADER, 'ProjectLeader'
      new :PROJECT_MANAGER, 'ProjectManager'
      new :PROJECT_MEMBER, 'ProjectMember'
      new :REGISTRATION_AGENCY, 'RegistrationAgency'
      new :REGISTRATION_AUTHORITY, 'RegistrationAuthority'
      new :RELATED_PERSON, 'RelatedPerson'
      new :RESEARCHER, 'Researcher'
      new :RESEARCH_GROUP, 'ResearchGroup'
      new :RIGHTS_HOLDER, 'RightsHolder'
      new :SPONSOR, 'Sponsor'
      new :SUPERVISOR, 'Supervisor'
      new :WORK_PACKAGE_LEADER, 'WorkPackageLeader'
      new :OTHER, 'Other'
    end

    # The institution or person responsible for collecting, creating, or otherwise contributing to the developement of the dataset.
    class Contributor
      include XML::Mapping

      # @!attribute [rw] name
      #   @return [String] the personal name of the contributor, in the format `Family, Given`. Cannot be empty or nil
      text_node :name, 'contributorName'

      # @!attribute [rw] identifier
      #   @return [NameIdentifier, nil] an identifier for the contributor. Optional.
      object_node :identifier, 'nameIdentifier', class: NameIdentifier

      # @!attribute [rw] affiliations
      #   @return [Array<String>] the contributor's affiliations. Defaults to an empty list.
      array_node :affiliations, 'affiliation', class: String

      # @!attribute [rw] type
      #   @return [ContributorType] the contributor type. Cannot be nil.
      typesafe_enum_node :type, '@contributorType', class: ContributorType

      alias_method :_name=, :name=
      alias_method :_type=, :type=
      private :_name=
      private :_type=

      # Initializes a new {Contributor}.
      # @param name [String] the personal name of the contributor, in the format `Family, Given`. Cannot be empty or nil
      # @param identifier [NameIdentifier, nil] an identifier for the contributor. Optional.
      # @param affiliations [Array<Affiliation>] the contributor's affiliations. Defaults to an empty list.
      # @param type [ContributorType] the contributor type. Cannot be nil.
      def initialize(name:, identifier: nil, affiliations: nil, type:)
        self.name = name
        self.identifier = identifier
        self.affiliations = affiliations || []
        self.type = type
      end

      def name=(value)
        fail ArgumentError, 'Name cannot be empty or nil' unless value && !value.empty?
        self._name = value
      end

      def type=(value)
        fail ArgumentError, 'Type cannot be nil' unless value
        self._type = value
      end
    end
  end
end
