# frozen_string_literal: true

require 'spec_helper'
require 'tmpdir'

module Datacite
  module Mapping

    describe Resource do

      attr_reader :identifier
      attr_reader :creators
      attr_reader :titles
      attr_reader :publisher
      attr_reader :publication_year
      attr_reader :args

      describe 'fields' do

        before(:each) do
          @identifier = Identifier.new(value: '10.14749/1407399495')

          @creators = [
            Creator.new(
              name: 'Hedy Lamarr',
              identifier: NameIdentifier.new(scheme: 'ISNI', scheme_uri: URI('http://isni.org/'), value: '0000-0001-1690-159X'),
              affiliations: ['United Artists', 'Metro-Goldwyn-Mayer']
            ),
            Creator.new(
              name: 'Herschlag, Natalie',
              identifier: NameIdentifier.new(scheme: 'ISNI', scheme_uri: URI('http://isni.org/'), value: '0000-0001-0907-8419'),
              affiliations: ['Gaumont Buena Vista International', '20th Century Fox']
            )
          ]

          @titles = [
            Title.new(value: 'An Account of a Very Odd Monstrous Calf', language: 'en-emodeng'),
            Title.new(type: TitleType::SUBTITLE, value: 'And a Contest between Two Artists about Optick Glasses, &c', language: 'en-emodeng')
          ]

          @publisher = 'California Digital Library'
          @publication_year = 2015

          @args = {
            identifier: identifier,
            creators: creators,
            titles: titles,
            publisher: publisher,
            publication_year: publication_year
          }
        end

        describe '#identifier' do
          it 'requires an identifier' do
            args.delete(:identifier)
            expect { Resource.new(**args) }.to raise_error(ArgumentError)
          end

          it 'requires a non-nil identifier' do
            args[:identifier] = nil
            expect { Resource.new(**args) }.to raise_error(ArgumentError)
          end

          it 'can be initialized' do
            resource = Resource.new(**args)
            expect(resource.identifier).to eq(identifier)
          end

          it 'can be set' do
            new_id = Identifier.new(value: '10.1594/WDCC/CCSRNIES_SRES_B2')
            resource = Resource.new(**args)
            resource.identifier = new_id
            expect(resource.identifier).to eq(new_id)
          end
        end

        describe '#creators' do

          it 'requires a creator list' do
            args.delete(:creators)
            expect { Resource.new(**args) }.to raise_error(ArgumentError)
          end

          it 'requires a non-nil creator list' do
            args[:creators] = nil
            expect { Resource.new(**args) }.to raise_error(ArgumentError)
          end

          it 'requires a non-empty creator list' do
            args[:creators] = []
            expect { Resource.new(**args) }.to raise_error(ArgumentError)
          end

          it 'can be initialized' do
            resource = Resource.new(**args)
            expect(resource.creators).to eq(creators)
          end

          it 'can be set' do
            new_creators = [Creator.new(
              name: 'Danica McKellar',
              identifier: NameIdentifier.new(scheme: 'ISNI', scheme_uri: URI('http://isni.org/'), value: '0000 0001 1678 4522'),
              affiliations: ['Disney–ABC Television Group']
            )]
            resource = Resource.new(**args)
            resource.creators = new_creators
            expect(resource.creators).to eq(new_creators)
          end

          describe 'creator convenience methods' do
            describe '#creator_names' do
              it 'extracts the creator names' do
                resource = Resource.new(**args)
                expect(resource.creator_names)
                  .to eq(['Hedy Lamarr', 'Herschlag, Natalie'])
              end
            end

            describe '#creator_affiliations' do
              it 'extracts the creator affiliations' do
                resource = Resource.new(**args)
                expect(resource.creator_affiliations)
                  .to eq([
                           ['United Artists', 'Metro-Goldwyn-Mayer'],
                           ['Gaumont Buena Vista International', '20th Century Fox']
                         ])
              end
            end
          end
        end

        describe '#titles' do
          it 'requires a title list' do
            args.delete(:titles)
            expect { Resource.new(**args) }.to raise_error(ArgumentError)
          end

          it 'requires a non-nil title list' do
            args[:titles] = nil
            expect { Resource.new(**args) }.to raise_error(ArgumentError)
          end

          it 'requires a non-empty title list' do
            args[:titles] = []
            expect { Resource.new(**args) }.to raise_error(ArgumentError)
          end

          it 'can be initialized' do
            resource = Resource.new(**args)
            expect(resource.titles).to eq(titles)
          end

          it 'can be set' do
            new_titles = [Title.new(
              language: 'en-emodeng',
              type: TitleType::SUBTITLE,
              value: 'Together with an Appendix of the Same, Containing an Answer to Some Objections, Made by Severall Persons against That Hypothesis'
            )]
            resource = Resource.new(**args)
            resource.titles = new_titles
            expect(resource.titles).to eq(new_titles)
          end

        end

        describe '#publisher' do
          it 'requires a publisher' do
            args.delete(:publisher)
            expect { Resource.new(**args) }.to raise_error(ArgumentError)
          end
          it 'requires a non-nil publisher' do
            args[:publisher] = nil
            expect { Resource.new(**args) }.to raise_error(ArgumentError)
          end
          it 'requires a non-blank publisher' do
            expect { Publisher.new(value: '   ') }.to raise_error(ArgumentError)
          end
          it 'can be initialized' do
            resource = Resource.new(**args)
            expect(resource.publisher.value).to eq(publisher)
          end
          it 'can be set' do
            new_publisher = 'University of California'
            resource = Resource.new(**args)
            resource.publisher = new_publisher
            expect(resource.publisher.value).to eq(new_publisher)
          end
          it 'strips on initialization' do
            args[:publisher] = Publisher.new(value: '
            University of California
             ')
            resource = Resource.new(**args)
            expect(resource.publisher.value).to eq('University of California')
          end
          it 'strips on set' do
            resource = Resource.new(**args)
            resource.publisher = Publisher.new(value: '
            University of California
              ')
            expect(resource.publisher.value).to eq('University of California')
          end
        end

        describe '#publication_year' do
          it 'requires a publication_year' do
            args.delete(:publication_year)
            expect { Resource.new(**args) }.to raise_error(ArgumentError)
          end
          it 'requires a non-nil publication_year' do
            args[:publication_year] = nil
            expect { Resource.new(**args) }.to raise_error(ArgumentError)
          end
          it 'requires a four-digit publication_year' do
            args[:publication_year] = 999
            expect { Resource.new(**args) }.to raise_error(ArgumentError)
            args[:publication_year] = 10_000
            expect { Resource.new(**args) }.to raise_error(ArgumentError)
          end
          it 'can be initialized' do
            resource = Resource.new(**args)
            expect(resource.publication_year).to eq(publication_year)
          end
          it 'can be set' do
            new_pub_year = 1963
            resource = Resource.new(**args)
            resource.publication_year = new_pub_year
            expect(resource.publication_year).to eq(new_pub_year)
          end
          it 'converts strings to integers' do
            new_pub_year = 1963
            resource = Resource.new(**args)
            resource.publication_year = new_pub_year.to_s
            expect(resource.publication_year).to eq(new_pub_year)
          end
        end

        describe '#subjects' do
          it 'defaults to empty' do
            resource = Resource.new(**args)
            expect(resource.subjects).to eq([])
          end

          describe 'subjects:' do
            it 'can be initialized' do
              subjects = [
                Subject.new(
                  language: 'en-us',
                  scheme: 'LCSH',
                  scheme_uri: URI('http://identifier.loc.gov/authorities/subjects'),
                  value: 'Mammals--Embryology'
                ),
                Subject.new(
                  language: 'fr',
                  scheme: 'dewey',
                  scheme_uri: URI('http://dewey.info/'),
                  value: '571.8 Croissance, développement, reproduction biologique (fécondation, sexualité)'
                )
              ]
              args[:subjects] = subjects
              resource = Resource.new(**args)
              expect(resource.subjects).to eq(subjects)
            end
            it 'can\'t be initialized to nil' do
              args[:subjects] = nil
              resource = Resource.new(**args)
              expect(resource.subjects).to eq([])
            end

            it 'ignores subjects without values' do
              subjects = [
                Subject.allocate,
                Subject.new(value: 'Mammals--Embryology'),
                Subject.allocate
              ]
              args[:subjects] = subjects
              resource = Resource.new(**args)
              expect(resource.subjects).to eq([subjects[1]])
            end
          end

          describe '#subjects=' do
            it 'can be set' do
              subjects = [
                Subject.new(
                  language: 'en-us',
                  scheme: 'LCSH',
                  scheme_uri: URI('http://identifier.loc.gov/authorities/subjects'),
                  value: 'Mammals--Embryology'
                ),
                Subject.new(
                  language: 'fr',
                  scheme: 'dewey',
                  scheme_uri: URI('http://dewey.info/'),
                  value: '571.8 Croissance, développement, reproduction biologique (fécondation, sexualité)'
                )
              ]
              resource = Resource.new(**args)
              resource.subjects = subjects
              expect(resource.subjects).to eq(subjects)
            end
            it 'can\'t be set to nil' do
              resource = Resource.new(**args)
              resource.subjects = nil
              expect(resource.subjects).to eq([])
            end
            it 'ignores subjects without values' do
              subjects = [
                Subject.allocate,
                Subject.new(value: 'Mammals--Embryology'),
                Subject.allocate
              ]
              resource = Resource.new(**args)
              resource.subjects = subjects
              expect(resource.subjects).to eq([subjects[1]])
            end
          end
        end

        describe '#funding_references' do
          it 'defaults to empty' do
            resource = Resource.new(**args)
            expect(resource.funding_references).to eq([])
          end

          describe 'funding_references:' do
            it 'can be initialized' do
              funding_references = [
                FundingReference.new(name: 'Ministry of Magic', award_number: '9¾'),
                FundingReference.new(name: 'НИИЧАВО', award_number: '164070')
              ]
              args[:funding_references] = funding_references
              resource = Resource.new(**args)
              expect(resource.funding_references).to eq(funding_references)
            end
            it 'can\'t be initialized to nil' do
              args[:funding_references] = nil
              resource = Resource.new(**args)
              expect(resource.funding_references).to eq([])
            end
          end

          describe '#funding_references=' do
            it 'can be set' do
              resource = Resource.new(**args)
              funding_references = [
                FundingReference.new(name: 'Ministry of Magic', award_number: '9¾'),
                FundingReference.new(name: 'НИИЧАВО', award_number: '164070')
              ]
              resource.funding_references = funding_references
              expect(resource.funding_references).to eq(funding_references)
            end
            it 'can\'t be set to nil' do
              resource = Resource.new(**args)
              resource.funding_references = nil
              expect(resource.funding_references).to eq([])
            end
          end
        end

        describe '#language' do
          it 'defaults to nil' do
            resource = Resource.new(**args)
            expect(resource.language).to be_nil
          end

          it 'can be initialized' do
            args[:language] = 'en-emodeng'
            resource = Resource.new(**args)
            expect(resource.language).to eq('en-emodeng')
          end

          it 'can be set' do
            resource = Resource.new(**args)
            resource.language = 'en-emodeng'
            expect(resource.language).to eq('en-emodeng')
          end
        end

        describe '#contributors' do

          it 'defaults to empty' do
            resource = Resource.new(**args)
            expect(resource.funding_references).to eq([])
          end

          describe 'contributors:' do
            it 'can be initialized' do
              contributors = [
                Contributor.new(name: 'Hershlag, Natalie', type: ContributorType::PROJECT_MEMBER),
                Contributor.new(name: 'Hedy Lamarr', type: ContributorType::RESEARCHER)
              ]
              args[:contributors] = contributors
              resource = Resource.new(**args)
              expect(resource.contributors).to eq(contributors)
            end
            it 'can\'t be initialized to nil' do
              args[:contributors] = nil
              resource = Resource.new(**args)
              expect(resource.contributors).to eq([])
            end
          end

          describe '#contributors=' do
            it 'can be set' do
              resource = Resource.new(**args)
              contributors = [
                Contributor.new(name: 'Hershlag, Natalie', type: ContributorType::PROJECT_MEMBER),
                Contributor.new(name: 'Hedy Lamarr', type: ContributorType::RESEARCHER)
              ]
              resource.contributors = contributors
              expect(resource.contributors).to eq(contributors)
            end
            it 'can\'t be set to nil' do
              resource = Resource.new(**args)
              resource.contributors = nil
              expect(resource.contributors).to eq([])
            end
          end

          describe 'contributor convenience methods' do
            before(:each) do
              @resource = Resource.new(**args)
              @funder = Contributor.new(
                name: 'The Ministry of Magic',
                identifier: NameIdentifier.new(
                  scheme: 'IATI',
                  scheme_uri: URI('http://iatistandard.org/201/codelists/OrganisationIdentifier/'),
                  value: 'GR-9¾'
                ),
                type: ContributorType::FUNDER
              )
              @resource.contributors << @funder
            end

            describe 'funder_contrib' do
              it 'extracts the funder contrib' do
                expect(@resource.funder_contrib).to eq(@funder)
              end
            end

            describe 'funder_name' do
              it 'extracts the funder name' do
                expect(@resource.funder_name).to eq(@funder.name)
              end
            end

            describe 'funder_id' do
              it 'extracts the funder id' do
                expect(@resource.funder_id).to eq(@funder.identifier)
              end
            end

            describe 'funder_id_value' do
              it 'extracts the funder id value' do
                expect(@resource.funder_id_value).to eq(@funder.identifier.value)
              end
            end
          end
        end

        describe '#dates' do
          it 'defaults to empty' do
            resource = Resource.new(**args)
            expect(resource.funding_references).to eq([])
          end

          describe 'dates:' do
            it 'can be initialized' do
              dates = [
                Date.new(value: DateTime.new(1914, 8, 4, 11, 0o1, 6.0123, '+1'), type: DateType::AVAILABLE),
                Date.new(value: '1914-08-04T11:01:06.0123+01:00', type: DateType::AVAILABLE)
              ]
              args[:dates] = dates
              resource = Resource.new(**args)
              expect(resource.dates).to eq(dates)
            end
            it 'can\'t be initialized to nil' do
              args[:dates] = nil
              resource = Resource.new(**args)
              expect(resource.dates).to eq([])
            end
          end

          describe '#dates=' do
            it 'can be set' do
              resource = Resource.new(**args)
              dates = [
                Date.new(value: DateTime.new(1914, 8, 4, 11, 0o1, 6.0123, '+1'), type: DateType::AVAILABLE),
                Date.new(value: '1914-08-04T11:01:06.0123+01:00', type: DateType::AVAILABLE)
              ]
              resource.dates = dates
              expect(resource.dates).to eq(dates)
            end
            it 'can\'t be set to nil' do
              resource = Resource.new(**args)
              resource.dates = nil
              expect(resource.dates).to eq([])
            end
          end
        end

        describe '#resource_type' do
          it 'can be initialized' do
            resource_type = ResourceType.new(resource_type_general: ResourceTypeGeneral::DATASET, value: 'Dataset')
            args[:resource_type] = resource_type
            resource = Resource.new(**args)
            expect(resource.resource_type).to eq(resource_type)
          end

          it 'can be set' do
            resource_type = ResourceType.new(resource_type_general: ResourceTypeGeneral::DATASET, value: 'Dataset')
            resource = Resource.new(**args)
            resource.resource_type = resource_type
            expect(resource.resource_type).to eq(resource_type)
          end
        end

        describe '#alternate_identifiers' do
          it 'defaults to empty' do
            resource = Resource.new(**args)
            expect(resource.alternate_identifiers).to eq([])
          end

          describe 'alternate_identifiers:' do
            it 'can be initialized' do
              alternate_identifiers = [
                AlternateIdentifier.new(type: 'URL', value: 'http://example.org'),
                AlternateIdentifier.new(type: 'URL', value: 'http://example.com')
              ]
              args[:alternate_identifiers] = alternate_identifiers
              resource = Resource.new(**args)
              expect(resource.alternate_identifiers).to eq(alternate_identifiers)
            end
            it 'can\'t be initialized to nil' do
              args[:alternate_identifiers] = nil
              resource = Resource.new(**args)
              expect(resource.alternate_identifiers).to eq([])
            end
          end

          describe '#alternate_identifiers=' do
            it 'can be set' do
              resource = Resource.new(**args)
              alternate_identifiers = [
                AlternateIdentifier.new(type: 'URL', value: 'http://example.org'),
                AlternateIdentifier.new(type: 'URL', value: 'http://example.com')
              ]
              resource.alternate_identifiers = alternate_identifiers
              expect(resource.alternate_identifiers).to eq(alternate_identifiers)
            end
            it 'can\'t be set to nil' do
              resource = Resource.new(**args)
              resource.alternate_identifiers = nil
              expect(resource.alternate_identifiers).to eq([])
            end
          end
        end

        describe '#related_identifiers' do
          it 'defaults to empty' do
            resource = Resource.new(**args)
            expect(resource.related_identifiers).to eq([])
          end

          describe 'related_identifiers:' do
            it 'can be initialized' do
              related_identifiers = [
                RelatedIdentifier.new(
                  identifier_type: RelatedIdentifierType::URL,
                  relation_type: RelationType::HAS_METADATA,
                  related_metadata_scheme: 'citeproc+json',
                  scheme_type: 'Turtle',
                  scheme_uri: URI('https://github.com/citation-style-language/schema/raw/master/csl-data.json'),
                  value: 'http://data.datacite.org/application/citeproc+json/10.5072/example-full'
                ),
                RelatedIdentifier.new(
                  identifier_type: RelatedIdentifierType::ARXIV,
                  relation_type: RelationType::IS_REVIEWED_BY,
                  value: 'arXiv:0706.0001'
                )
              ]
              args[:related_identifiers] = related_identifiers
              resource = Resource.new(**args)
              expect(resource.related_identifiers).to eq(related_identifiers)
            end
            it 'can\'t be initialized to nil' do
              args[:related_identifiers] = nil
              resource = Resource.new(**args)
              expect(resource.related_identifiers).to eq([])
            end
          end

          describe '#related_identifiers=' do
            it 'can be set' do
              resource = Resource.new(**args)
              related_identifiers = [
                RelatedIdentifier.new(
                  identifier_type: RelatedIdentifierType::URL,
                  relation_type: RelationType::HAS_METADATA,
                  related_metadata_scheme: 'citeproc+json',
                  scheme_type: 'Turtle',
                  scheme_uri: URI('https://github.com/citation-style-language/schema/raw/master/csl-data.json'),
                  value: 'http://data.datacite.org/application/citeproc+json/10.5072/example-full'
                ),
                RelatedIdentifier.new(
                  identifier_type: RelatedIdentifierType::ARXIV,
                  relation_type: RelationType::IS_REVIEWED_BY,
                  value: 'arXiv:0706.0001'
                )
              ]
              resource.related_identifiers = related_identifiers
              expect(resource.related_identifiers).to eq(related_identifiers)
            end
            it 'can\'t be set to nil' do
              resource = Resource.new(**args)
              resource.related_identifiers = nil
              expect(resource.related_identifiers).to eq([])
            end
          end
        end

        describe '#sizes' do
          it 'defaults to empty' do
            resource = Resource.new(**args)
            expect(resource.sizes).to eq([])
          end

          describe 'sizes:' do
            it 'can be initialized' do
              sizes = %w[48K 128K]
              args[:sizes] = sizes
              resource = Resource.new(**args)
              expect(resource.sizes).to eq(sizes)
            end
            it 'can\'t be initialized to nil' do
              args[:sizes] = nil
              resource = Resource.new(**args)
              expect(resource.sizes).to eq([])
            end
          end

          describe '#sizes=' do
            it 'can be set' do
              sizes = %w[48K 128K]
              resource = Resource.new(**args)
              resource.sizes = sizes
              expect(resource.sizes).to eq(sizes)
            end
            it 'can\'t be set to nil' do
              resource = Resource.new(**args)
              resource.sizes = nil
              expect(resource.sizes).to eq([])
            end
          end
        end

        describe '#formats' do
          it 'defaults to empty' do
            resource = Resource.new(**args)
            expect(resource.formats).to eq([])
          end

          describe 'formats:' do
            it 'can be initialized' do
              formats = %w[D64 DSK]
              args[:formats] = formats
              resource = Resource.new(**args)
              expect(resource.formats).to eq(formats)
            end
            it 'can\'t be initialized to nil' do
              args[:formats] = nil
              resource = Resource.new(**args)
              expect(resource.formats).to eq([])
            end
          end

          describe '#formats=' do
            it 'can be set' do
              formats = %w[D64 DSK]
              resource = Resource.new(**args)
              resource.formats = formats
              expect(resource.formats).to eq(formats)
            end
            it 'can\'t be set to nil' do
              resource = Resource.new(**args)
              resource.formats = nil
              expect(resource.formats).to eq([])
            end
          end
        end

        describe '#version' do
          it 'defaults to nil' do
            resource = Resource.new(**args)
            expect(resource.version).to be_nil
          end
          it 'can be initialized' do
            args[:version] = '9.2.2'
            resource = Resource.new(**args)
            expect(resource.version).to eq('9.2.2')
          end
          it 'can be set' do
            new_version = '9.2.2'
            resource = Resource.new(**args)
            resource.version = new_version
            expect(resource.version).to eq(new_version)
          end
          it 'strips on initialization' do
            args[:version] = '
            9.2.2
          '
            resource = Resource.new(**args)
            expect(resource.version).to eq('9.2.2')
          end
          it 'strips on set' do
            resource = Resource.new(**args)
            resource.version = '
            9.2.2
          '
            expect(resource.version).to eq('9.2.2')
          end
          it 'accepts a float' do
            resource = Resource.new(**args)
            resource.version = 9.2
            expect(resource.version).to eq('9.2')
          end
          it 'accepts an integer' do
            resource = Resource.new(**args)
            resource.version = 9
            expect(resource.version).to eq('9')
          end
          it 'can be initialized' do
            args[:version] = '9.2.2'
            resource = Resource.new(**args)
            expect(resource.version).to eq('9.2.2')
          end
          it 'can be set to nil' do
            args[:version] = '9.2.2'
            resource = Resource.new(**args)
            resource.version = nil
            expect(resource.version).to be_nil
          end
        end

        describe '#rights_list' do
          it 'defaults to empty' do
            resource = Resource.new(**args)
            expect(resource.rights_list).to eq([])
          end

          describe('rights_list:') do
            it 'can be initialized' do
              rights_list = [
                Rights.new(value: 'CC0 1.0 Universal', uri: URI('http://creativecommons.org/publicdomain/zero/1.0/')),
                Rights.new(value: 'This work is free of known copyright restrictions.', uri: URI('http://creativecommons.org/publicdomain/mark/1.0/'))
              ]
              args[:rights_list] = rights_list
              resource = Resource.new(**args)
              expect(resource.rights_list).to eq(rights_list)
            end
            it 'can\'t be initialized to nil' do
              args[:rights_list] = nil
              resource = Resource.new(**args)
              expect(resource.rights_list).to eq([])
            end
          end

          describe '#rights_list=' do
            it 'can be set' do
              resource = Resource.new(**args)
              rights_list = [
                Rights.new(value: 'CC0 1.0 Universal', uri: URI('http://creativecommons.org/publicdomain/zero/1.0/')),
                Rights.new(value: 'This work is free of known copyright restrictions.', uri: URI('http://creativecommons.org/publicdomain/mark/1.0/'))
              ]
              resource.rights_list = rights_list
              expect(resource.rights_list).to eq(rights_list)
            end

            it 'can\'t be set to nil' do
              resource = Resource.new(**args)
              resource.rights_list = nil
              expect(resource.rights_list).to eq([])
            end
          end

        end

        describe '#descriptions' do
          it 'defaults to empty' do
            resource = Resource.new(**args)
            expect(resource.descriptions).to eq([])
          end

          describe 'descriptions:' do
            it 'can be initialized' do
              descriptions = [
                Description.new(language: 'en-us', type: DescriptionType::ABSTRACT, value: 'Exterminate all the brutes!'),
                Description.new(language: 'en-us', type: DescriptionType::METHODS, value: 'unsound')
              ]
              args[:descriptions] = descriptions
              resource = Resource.new(**args)
              expect(resource.descriptions).to eq(descriptions)
            end
            it 'can\'t be initialized to nil' do
              args[:descriptions] = nil
              resource = Resource.new(**args)
              expect(resource.descriptions).to eq([])
            end

            it 'ignores descriptions without values' do
              descriptions = [
                Description.allocate,
                Description.new(language: 'en-us', type: DescriptionType::METHODS, value: 'unsound'),
                Description.allocate
              ]
              args[:descriptions] = descriptions
              resource = Resource.new(**args)
              expect(resource.descriptions).to eq([descriptions[1]])
            end
          end

          describe '#descriptions=' do
            it 'can be set' do
              descriptions = [
                Description.new(language: 'en-us', type: DescriptionType::ABSTRACT, value: 'Exterminate all the brutes!'),
                Description.new(language: 'en-us', type: DescriptionType::METHODS, value: 'unsound')
              ]
              resource = Resource.new(**args)
              resource.descriptions = descriptions
              expect(resource.descriptions).to eq(descriptions)
            end
            it 'can\'t be set to nil' do
              resource = Resource.new(**args)
              resource.descriptions = nil
              expect(resource.descriptions).to eq([])
            end

            it 'ignores descriptions without values' do
              descriptions = [
                Description.allocate,
                Description.new(language: 'en-us', type: DescriptionType::METHODS, value: 'unsound'),
                Description.allocate
              ]
              resource = Resource.new(**args)
              resource.descriptions = descriptions
              expect(resource.descriptions).to eq([descriptions[1]])
            end
          end
        end

        describe '#geo_locations' do
          it 'defaults to empty' do
            resource = Resource.new(**args)
            expect(resource.geo_locations).to eq([])
          end

          describe 'geo_locations:' do
            it 'can be initialized' do
              geo_locations = [
                GeoLocation.new(point: GeoLocationPoint.new(47.61, -122.33)),
                GeoLocation.new(box: GeoLocationBox.new(-33.45, -122.33, 47.61, -70.67))
              ]
              args[:geo_locations] = geo_locations
              resource = Resource.new(**args)
              expect(resource.geo_locations).to eq(geo_locations)
            end
            it 'can\'t be initialized to nil' do
              args[:geo_locations] = nil
              resource = Resource.new(**args)
              expect(resource.geo_locations).to eq([])
            end
            it 'ignores empty locations' do
              geo_locations = [
                GeoLocation.new,
                GeoLocation.new(point: GeoLocationPoint.new(47.61, -122.33)),
                GeoLocation.new
              ]
              args[:geo_locations] = geo_locations
              resource = Resource.new(**args)
              expect(resource.geo_locations).to eq([geo_locations[1]])
            end
          end

          describe '#geo_locations=' do
            it 'can be set' do
              resource = Resource.new(**args)
              geo_locations = [
                GeoLocation.new(point: GeoLocationPoint.new(47.61, -122.33)),
                GeoLocation.new(box: GeoLocationBox.new(-33.45, -122.33, 47.61, -70.67))
              ]
              resource.geo_locations = geo_locations
              expect(resource.geo_locations).to eq(geo_locations)
            end
            it 'can\'t be set to nil' do
              resource = Resource.new(**args)
              resource.geo_locations = nil
              expect(resource.geo_locations).to eq([])
            end
            it 'ignores empty locations' do
              resource = Resource.new(**args)
              geo_locations = [
                GeoLocation.new,
                GeoLocation.new(point: GeoLocationPoint.new(47.61, -122.33)),
                GeoLocation.new
              ]
              resource.geo_locations = geo_locations
              expect(resource.geo_locations).to eq([geo_locations[1]])
            end
          end
        end

      end

      describe 'compatibility' do

        def xml_text_from(file, fix_dash1)
          xml_text = File.read(file)
          xml_text = fix_dash1(xml_text) if fix_dash1
          xml_text
        end

        def parse_file(xml_text, basename)
          Resource.parse_xml(xml_text)
        rescue Exception => e # rubocop:disable Lint/RescueException
          warn "Error parsing #{basename}: #{e}"
          File.open("tmp/#{basename}-xml_text.xml", 'w') { |t| t.write(xml_text) }
          File.open("tmp/#{basename}-parse_error.xml", 'w') { |t| t.write(xml_text) }
          raise
        end

        def write_xml(resource, basename, options)
          # Workaround for Dash 1 datacite.xml with missing DOI
          resource.identifier = Identifier.from_doi('10.5555/12345678') unless resource.identifier
          resource.write_xml(options)
        rescue Exception => e # rubocop:disable Lint/RescueException
          warn "Error writing #{basename}: #{e}"
          raise
        end

        def normalize(xml_str)
          r0 = xml_str
          r1 = r0.gsub(%r{&lt;br\s+/&gt;}, '<br/>') # entity-de-escape <br/> tags
          # r2 = r1.gsub(%r{<(?!br)[^>]+/>}, '') # remove empty tags
          r2 = r1
          r3 = r2.gsub(/<resource (xmlns:xsi="[^"]+")\s+(xsi:schemaLocation="[^"]+")>/, '<resource \\2 \\1 xmlns="http://datacite.org/schema/kernel-3">') # fix missing namespace
          r4 = r3.gsub(%r{(<identifier[^>]+>)\s*([^ ]+)\s*(</identifier>)}, '\\1\\2\\3') # trim identifiers
          r5 = r4.gsub(%r{<([^>]+tude)>([0-9.-]+?)(0?)0+</\1>}, '<\\1>\\2\\3</\\1>') # strip trailing coordinate zeroes
          r6 = r5.gsub(%r{<(geoLocation[^>]+)>[^<]+</\1>}) { |loc| loc.gsub(/([0-9-]+\.[0-9]+?)0+([^0-9])/, '\\1\\2') } # strip trailing coordinate zeroes
          r7 = r6.gsub(%r{<([A-Za-z]*)[^>]*>\s*</\1>}, '') # remove empty tag pairs
          to_pretty(r7)
          # if r8.include?('&lt;br')
          #   trace = [r0, r1, r2, r3, r4, r5, r6, r7, r8].map { |r| r.include?('&lt;br') }
          #   puts trace
          # end
        end

        def to_pretty(xml_text)
          xml = REXML::Document.new(xml_text).root
          formatter = REXML::Formatters::Pretty.new
          formatter.compact = true
          io = ::StringIO.new
          formatter.write(xml, io)
          io.string
        end

        def fix_dash1(xml_str)
          # Workaround for Dash 1 datacite.xml with:
          # - missing DOI
          # - empty tags
          # - nested contributors instead of contributorNames

          r0 = xml_str
          r1 = r0.gsub(%r{<(?!br)[^>]+/>}, '') # remove empty tags
          r2 = r1.gsub(%r{<([A-Za-z]*)[^>]*>\s*</\1>}, '') # remove empty tag pairs
          r3 = r2.gsub(%r{(<date[^>]*>)(\d{4})-(\d{4})(</date>)}, '\\1\\2/\\3\\4') # fix date ranges
          r3.gsub(%r{(<contributor[^>/]+>\s*)<contributor>([^<]+)</contributor>(\s*</contributor>)}, '\\1<contributorName>\\2</contributorName>\\3') # fix broken contributors
        end

        def it_round_trips(file:, mapping: :_default, fix_dash1: false)
          options = { mapping: mapping }
          basename = File.basename(file)
          xml_text = xml_text_from(file, fix_dash1)
          expected_xml = normalize(xml_text)
          resource = parse_file(expected_xml, basename)
          actual_xml = write_xml(resource, basename, options)
          expected_xml.gsub!(/(<resource[^>]+>)\s+(<creators>)/, "\\1\n  <identifier identifierType=\"DOI\">10.5555/12345678</identifier>\n  \\2") if fix_dash1
          begin
            expect(actual_xml).to be_xml(expected_xml)
          rescue Exception # rubocop:disable Lint/RescueException
            File.open("/tmp/#{basename}-expected.xml", 'w') { |t| t.write(expected_xml) }
            File.open("/tmp/#{basename}-actual.xml", 'w') { |t| t.write(actual_xml) }
            raise
          end
        end

        it 'reads all datacite 4 example documents' do
          Dir.glob('spec/data/datacite4/datacite-example-*.xml') { |f| it_round_trips(file: f) }
        end
        it 'reads all datacite 3 example documents' do
          Dir.glob('spec/data/datacite3/datacite-example-*.xml') { |f| it_round_trips(file: f, mapping: :datacite_3) }
        end
        it 'reads all dash 1 docs, with caveats' do
          Dir.glob('spec/data/dash1/*.xml') { |f| it_round_trips(file: f, mapping: :datacite_3, fix_dash1: true) }
        end

        describe 'DC4 to DC3' do

          attr_reader :resource
          attr_reader :rexml
          attr_reader :warnings

          def warnings_including(substring)
            warnings.select { |w| w.include?(substring) }
          end

          def expect_warning(substring, count, include_matches = false)
            matches = warnings_including(substring)
            found_count = matches.size
            msg = "expected #{count} warnings including '#{substring}', found #{found_count}"
            msg += ": #{matches}" if include_matches
            expect(found_count).to eq(count), msg
          end

          def expect_matches(xpath, count, include_matches = false)
            matches = REXML::XPath.match(rexml, xpath)
            found_count = matches.size
            msg = "expected #{count} matches for XPath '#{xpath}', found #{found_count}"
            msg += ": #{matches}" if include_matches
            expect(found_count).to eq(count), msg
          end

          before(:each) do
            @warnings = []
            allow(ReadOnlyNodes).to receive(:warn) do |w|
              warnings << w
              # Kernel.warn(w) # for debugging
            end

            xml = File.read('spec/data/datacite-4-synthetic.xml')
            @resource = Resource.parse_xml(xml)
            @rexml = resource.save_to_xml(mapping: :datacite_3)
          end

          it 'sets the kernel-3 namespace' do
            expect(rexml.namespace).to eq(DATACITE_3_NAMESPACE.uri)
          end

          it 'still writes DC4 by default after writing DC3' do
            dc4xml = resource.save_to_xml
            expect(dc4xml.namespace).to eq(DATACITE_4_NAMESPACE.uri)
          end

          it 'warns about givenNames and familyNames' do
            name_tags = %w[givenName familyName]
            name_tags.each do |tag|
              expect_matches("//#{tag}", 0, true)
              expect_warning(tag, 1)
            end
          end

          it 'warns about FundingReferences' do
            expect_matches('//fundingReferences', 0, true)
            expect_warning('fundingReferences', 1)
          end

          it 'warns about IGSN identifiers' do
            expect_warning('IGSN', 1)
          end

          it 'warns about geoLocationPolygons' do
            expect_warning('geoLocationPolygon', 1)
          end

        end

        describe 'DC3 to DC4' do
          attr_reader :resource
          attr_reader :rexml

          before(:each) do
            @resource = Resource.load_from_file('spec/data/datacite3/datacite-example-full-v3.1.xml')
            @rexml = resource.save_to_xml
          end

          it 'writes a DC3 document as DC4' do
            expect(rexml.namespace).to eq(DATACITE_4_NAMESPACE.uri)
          end
        end
      end

      describe '#namespace_prefix=' do

        attr_reader :dcs3_xml
        attr_reader :dcs4_xml

        before(:each) do
          @dcs3_xml = '<dcs:resource xmlns:dcs="http://datacite.org/schema/kernel-3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://datacite.org/schema/kernel-3 http://schema.datacite.org/meta/kernel-3/metadata.xsd">
                        <dcs:identifier identifierType="DOI">10.14749/1407399495</dcs:identifier>
                        <dcs:creators>
                          <dcs:creator>
                            <dcs:creatorName>Hedy Lamarr</dcs:creatorName>
                            <dcs:nameIdentifier nameIdentifierScheme="ISNI" schemeURI="http://isni.org/">0000-0001-1690-159X</dcs:nameIdentifier>
                            <dcs:affiliation>United Artists</dcs:affiliation>
                            <dcs:affiliation>Metro-Goldwyn-Mayer</dcs:affiliation>
                          </dcs:creator>
                          <dcs:creator>
                            <dcs:creatorName>Herschlag, Natalie</dcs:creatorName>
                            <dcs:nameIdentifier nameIdentifierScheme="ISNI" schemeURI="http://isni.org/">0000-0001-0907-8419</dcs:nameIdentifier>
                            <dcs:affiliation>Gaumont Buena Vista International</dcs:affiliation>
                            <dcs:affiliation>20th Century Fox</dcs:affiliation>
                          </dcs:creator>
                        </dcs:creators>
                        <dcs:titles>
                          <dcs:title xml:lang="en-emodeng">An Account of a Very Odd Monstrous Calf</dcs:title>
                          <dcs:title xml:lang="en-emodeng" titleType="Subtitle">And a Contest between Two Artists about Optick Glasses, &amp;c</dcs:title>
                        </dcs:titles>
                        <dcs:publisher>California Digital Library</dcs:publisher>
                        <dcs:publicationYear>2015</dcs:publicationYear>
                        <dcs:language>en</dcs:language>
                      </dcs:resource>'
          @dcs4_xml = dcs3_xml.gsub('kernel-3', 'kernel-4')
        end

        it 'reads DC3 with namespace prefix' do
          resource = Resource.parse_xml(dcs3_xml)
          expect(resource.save_to_xml(mapping: :datacite_3)).to be_xml(dcs3_xml)
        end

        it 'writes DC3 with namespace prefix' do
          resource = Resource.parse_xml(dcs3_xml)
          resource.namespace_prefix = 'dcs'
          xml = resource.write_xml(mapping: :datacite_3)
          expect(xml).not_to match(%r{<[a-z "=/]+>})
          expect(xml).to match(%r{<dcs:[a-z "=/]+>})
        end

        it 'reads DC4 with namespace prefix' do
          resource = Resource.parse_xml(dcs4_xml)
          expect(resource.save_to_xml).to be_xml(dcs4_xml)
        end

        it 'writes DC4 with namespace prefix' do
          resource = Resource.parse_xml(dcs4_xml)
          resource.namespace_prefix = 'dcs'
          xml = resource.write_xml
          expect(xml).not_to match(%r{<[a-z "=/]+>})
          expect(xml).to match(%r{<dcs:[a-z "=/]+>})
        end

      end

      describe '#save_to_file' do
        it 'saves to a file' do
          xml_text = File.read('spec/data/datacite4/datacite-example-full-v4.xml')
          resource = Resource.parse_xml(xml_text)
          Dir.mktmpdir('resource_spec') do |dir|
            path = "#{dir}/resource.xml"
            resource.save_to_file(path)
            actual = File.read(path)
            expected = xml_text.gsub('41.090', '41.09')
            expect(actual).to be_xml(expected)
          end
        end
      end

      describe '#save_to_xml' do

        attr_reader :resource

        before(:each) do
          @identifier = Identifier.new(value: '10.14749/1407399495')

          @creators = [
            Creator.new(
              name: 'Hedy Lamarr',
              identifier: NameIdentifier.new(scheme: 'ISNI', scheme_uri: URI('http://isni.org/'), value: '0000-0001-1690-159X'),
              affiliations: ['United Artists', 'Metro-Goldwyn-Mayer']
            ),
            Creator.new(
              name: 'Herschlag, Natalie',
              identifier: NameIdentifier.new(scheme: 'ISNI', scheme_uri: URI('http://isni.org/'), value: '0000-0001-0907-8419'),
              affiliations: ['Gaumont Buena Vista International', '20th Century Fox']
            )
          ]

          @titles = [
            Title.new(value: 'An Account of a Very Odd Monstrous Calf', language: 'en-emodeng'),
            Title.new(type: TitleType::SUBTITLE, value: 'And a Contest between Two Artists about Optick Glasses, &c', language: 'en-emodeng')
          ]

          @publisher = 'California Digital Library'
          @publication_year = 2015

          @resource = Resource.new(
            identifier: identifier,
            creators: creators,
            titles: titles,
            publisher: publisher,
            publication_year: publication_year
          )
        end

        it 'sets the DC4 namespace by default' do
          xml = resource.save_to_xml
          expect(xml).to be_a(REXML::Element)
          expect(xml.namespace).to eq(DATACITE_4_NAMESPACE.uri)
        end

        it 'sets the DC3 namespace for the :datacite_3 mapping' do
          xml = resource.save_to_xml(mapping: :datacite_3)
          expect(xml).to be_a(REXML::Element)
          expect(xml.namespace).to eq(DATACITE_3_NAMESPACE.uri)
        end

        it 'fails on nil identifiers' do
          resource.instance_variable_set(:@identifier, nil)
          expect { resource.save_to_xml }.to raise_error(XML::MappingError)
        end
      end

      describe '#parse_xml' do

        attr_reader :xml_text

        before(:each) do
          @xml_text = "<resource xsi:schemaLocation='http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4/metadata.xsd' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns='http://datacite.org/schema/kernel-4'>
            <identifier identifierType='DOI'>10.14749/1407399495</identifier>
            <creators>
              <creator>
                <creatorName>Hedy Lamarr</creatorName>
                <nameIdentifier nameIdentifierScheme='ISNI' schemeURI='http://isni.org/'>0000-0001-1690-159X</nameIdentifier>
                <affiliation>United Artists</affiliation>
                <affiliation>Metro-Goldwyn-Mayer</affiliation>
              </creator>
              <creator>
                <creatorName>Herschlag, Natalie</creatorName>
                <nameIdentifier nameIdentifierScheme='ISNI' schemeURI='http://isni.org/'>0000-0001-0907-8419</nameIdentifier>
                <affiliation>Gaumont Buena Vista International</affiliation>
                <affiliation>20th Century Fox</affiliation>
              </creator>
            </creators>
            <titles>
              <title xml:lang='en-emodeng'>An Account of a Very Odd Monstrous Calf</title>
              <title xml:lang='en-emodeng' titleType='Subtitle'>And a Contest between Two Artists about Optick Glasses, &amp;c</title>
            </titles>
            <publisher>California Digital Library</publisher>
            <publicationYear>2015</publicationYear>
            <subjects>
              <subject xml:lang='en-us' schemeURI='http://id.loc.gov/authorities/subjects' subjectScheme='LCSH'>Mammals--Embryology</subject>
            </subjects>
            <descriptions>
              <description xml:lang='en-us' descriptionType='Abstract'>foo</description>
            </descriptions>
          </resource>"
        end

        it 'skips empty identifiers' do
          sketchy_xml = xml_text.gsub(%r{<identifier.*/identifier>}, '<identifier/>')
          resource = Resource.parse_xml(sketchy_xml)
          expect(resource).to be_a(Resource)
        end

        it 'skips empty subjects' do
          sketchy_xml = xml_text.gsub(%r{>[^<]+</subject>}, '/>')
          resource = Resource.parse_xml(sketchy_xml)
          expect(resource).to be_a(Resource)
          expect(resource.subjects).to eq([])
        end

        it 'skips empty descriptions' do
          sketchy_xml = xml_text.gsub(%r{>[^<]+</description>}, '/>')
          resource = Resource.parse_xml(sketchy_xml)
          expect(resource).to be_a(Resource)
          expect(resource.descriptions).to eq([])
        end
      end
    end
  end
end
