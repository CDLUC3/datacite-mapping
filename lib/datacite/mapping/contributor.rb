# frozen_string_literal: true

require 'xml/mapping_extensions'
require 'datacite/mapping/name_identifier'
require 'datacite/mapping/contributor_name'

module Datacite
  module Mapping

    # Controlled vocabulary of contributor types.
    class ContributorType < TypesafeEnum::Base
      # @!parse CONTACT_PERSON = ContactPerson
      new :CONTACT_PERSON, 'ContactPerson'

      # @!parse DATA_COLLECTOR = DataCollector
      new :DATA_COLLECTOR, 'DataCollector'

      # @!parse DATA_CURATOR = DataCurator
      new :DATA_CURATOR, 'DataCurator'

      # @!parse DATA_MANAGER = DataManager
      new :DATA_MANAGER, 'DataManager'

      # @!parse DISTRIBUTOR = Distributor
      new :DISTRIBUTOR, 'Distributor'

      # @!parse EDITOR = Editor
      new :EDITOR, 'Editor'

      # @deprecated contributor type 'funder' is deprecated. Use {FundingReference} instead.
      # @!parse FUNDER = Funder
      new :FUNDER, 'Funder'

      # @!parse HOSTING_INSTITUTION = HostingInstitution
      new :HOSTING_INSTITUTION, 'HostingInstitution'

      # @!parse PRODUCER = Producer
      new :PRODUCER, 'Producer'

      # @!parse PROJECT_LEADER = ProjectLeader
      new :PROJECT_LEADER, 'ProjectLeader'

      # @!parse PROJECT_MANAGER = ProjectManager
      new :PROJECT_MANAGER, 'ProjectManager'

      # @!parse PROJECT_MEMBER = ProjectMember
      new :PROJECT_MEMBER, 'ProjectMember'

      # @!parse REGISTRATION_AGENCY = RegistrationAgency
      new :REGISTRATION_AGENCY, 'RegistrationAgency'

      # @!parse REGISTRATION_AUTHORITY = RegistrationAuthority
      new :REGISTRATION_AUTHORITY, 'RegistrationAuthority'

      # @!parse RELATED_PERSON = RelatedPerson
      new :RELATED_PERSON, 'RelatedPerson'

      # @!parse RESEARCHER = Researcher
      new :RESEARCHER, 'Researcher'

      # @!parse RESEARCH_GROUP = ResearchGroup
      new :RESEARCH_GROUP, 'ResearchGroup'

      # @!parse RIGHTS_HOLDER = RightsHolder
      new :RIGHTS_HOLDER, 'RightsHolder'

      # @!parse SPONSOR = Sponsor
      new :SPONSOR, 'Sponsor'

      # @!parse SUPERVISOR = Supervisor
      new :SUPERVISOR, 'Supervisor'

      # @!parse WORK_PACKAGE_LEADER = WorkPackageLeader
      new :WORK_PACKAGE_LEADER, 'WorkPackageLeader'

      # @!parse OTHER = Other
      new :OTHER, 'Other'

    end

    # The institution or person responsible for collecting, creating, or otherwise contributing to the developement of the dataset.
    class Contributor
      include XML::Mapping

      # Initializes a new {Contributor}.
      # @param name [String] the personal name of the contributor, in the format `Family, Given`. Cannot be empty or nil
      # @param identifier [NameIdentifier, nil] an identifier for the contributor. Optional.
      # @param affiliations [Array<Affiliation>] the contributor's affiliations. Defaults to an empty list.
      # @param type [ContributorType] the contributor type. Cannot be nil.
      def initialize(name:, type:, identifier: nil, affiliations: nil)
        self.name = name
        self.identifier = identifier
        self.affiliations = affiliations || []
        self.type = type
      end

      # name can be entered as a string or a ContributorName object, but it will be stored
      # internally as a ContributorName object
      def name=(value)
        raise ArgumentError, 'Name cannot be empty or nil' unless value

        @contributor_name = if value.is_a?(ContributorName)
                              value
                            else
                              ContributorName.new(value: value)
                            end
      end

      def contributor_name=(value)
        raise ArgumentError, 'ContributorName cannot be empty or nil' unless value

        @contributor_name = value
      end

      def name
        @contributor_name&.value
      end

      def type=(value)
        raise ArgumentError, 'Type cannot be nil' unless value

        @type = value
      end

      # @!attribute [rw] name
      #   @return [String] The personal name of the creator, in the format `Family, Given`. Cannot be empty or nil.
      object_node :contributor_name, 'contributorName', class: ContributorName

      # @!attribute [rw] given_name
      #   @return [String, nil] The given name of the creator. Optional.
      text_node :given_name, 'givenName', default_value: nil

      # @!attribute [rw] family_name
      #   @return [String, nil] The family name of the creator. Optional.
      text_node :family_name, 'familyName', default_value: nil

      # @!attribute [rw] identifier
      #   @return [NameIdentifier, nil] an identifier for the contributor. Optional.
      object_node :identifier, 'nameIdentifier', class: NameIdentifier, default_value: nil

      # @!attribute [rw] affiliations
      #   @return [Array<String>] the contributor's affiliations. Defaults to an empty list.
      array_node :affiliations, 'affiliation', class: Affiliation, default_value: []

      # @!attribute [rw] type
      #   @return [ContributorType] the contributor type. Cannot be nil.
      typesafe_enum_node :type, '@contributorType', class: ContributorType

      fallback_mapping :datacite_3, :_default
    end
  end
end
