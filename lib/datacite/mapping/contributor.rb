require 'xml/mapping_extensions'
require_relative 'name_identifier'

module Datacite
  module Mapping

    class ContributorType < TypesafeEnum::Base
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

    class Contributor
      include XML::Mapping

      text_node :name, 'contributorName'
      object_node :identifier, 'nameIdentifier', class: NameIdentifier
      array_node :affiliations, 'affiliation', class: String
      typesafe_enum_node :type, '@contributorType', class: ContributorType

      def initialize(name:, identifier: nil, affiliations: nil, type:)
        self.name = name
        self.identifier = identifier
        self.affiliations = affiliations || []
        self.type = type
      end
    end

    # Not to be instantiated directly -- just call `Resource#contributors`
    class Contributors
      include XML::Mapping
      array_node :contributors, 'contributor', class: Contributor

      def initialize(contributors:)
        self.contributors = contributors || []
      end
    end
  end
end
