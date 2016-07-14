require 'xml/mapping'

module Datacite
  module Mapping
    module Nonvalidating
      # Subject, keyword, classification code, or key phrase describing the {Resource}.
      class Subject
        include XML::Mapping

        use_mapping :nonvalidating

        text_node :scheme, '@subjectScheme', default_value: nil
        uri_node :scheme_uri, '@schemeURI', default_value: nil
        text_node :language, '@xml:lang', default_value: 'en'
        text_node :value, 'text()', default_value: nil

        fallback_mapping(:_default, :nonvalidating)

        # Initializes a new {Subject}
        # @param scheme [String, nil] the subject scheme or classification code or authority if one is used. Optional.
        # @param scheme_uri [URI, nil] the URI of the subject scheme or classification code or authority if one is used. Optional.
        # @param language [String] an IETF BCP 47, ISO 639-1 language code identifying the language.
        #   It's unclear from the spec whether language is required; to play it safe, if it's missing, we default to 'en'.
        # @param value [String] the subject itself.
        def initialize(scheme: nil, scheme_uri: nil, language: 'en', value: nil)
          self.scheme = scheme
          self.scheme_uri = scheme_uri
          self.language = language
          self.value = value
        end

        def language
          @language || 'en'
        end

        def language=(value)
          @language = value.strip if value
        end

      end
    end
  end
end
