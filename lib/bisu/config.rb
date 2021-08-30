module Bisu
  class Config
    def initialize(hash:)
      @hash = hash.deep_symbolize
      @hash.validate_structure!(CONFIG_STRUCT)

      unless dict_struct = DICTIONARY_STRUCT[@hash[:dictionary][:type]]
        raise ArgumentError.new("unknown dictionary type '#{@hash[:dictionary][:type]}'")
      end

      @hash[:dictionary].validate_structure!(dict_struct)
    end

    def to_h
      @hash
    end

    def dictionary
      @hash[:dictionary]
    end

    def type
      @hash[:type]
    end

    def localize_files
      @hash[:translate].each do |t|
        @hash[:languages].each do |l|
          downcase_locale = l[:locale].downcase.gsub("-", "_").gsub(" ", "_")
          yield(t[:in], (t[:"out_#{downcase_locale}"] || t[:out]) % l, l[:locale], l[:language], l[:fallback_language])
        end
      end
    end

    private

    CONFIG_STRUCT = {
      type: Hash,
      elements: {
        type: { type: String },
        dictionary: { type: Hash, elements: {
          type: { type: String }
        } },
        translate: { type: Array, elements: {
          type: Hash, elements: {
            in: { type: String },
            out: { type: String }
          }
        } },
        languages: { type: Array, elements: {
          type: Hash, elements: {
            locale: { type: String },
            language: { type: String },
            fallback_language: { type: String, optional: true }
          }
        } }
      }
    }

    GOOGLE_SHEET_STRUCT = {
      type: Hash,
      elements: {
        type: { type: String },
        url: { type: String },
      },
    }

    ONE_SKY_STRUCT = {
      type: Hash,
      elements: {
        api_key: { type: String },
        api_secret: { type: String },
        project_id: { type: Integer },
        file_name: { type: String },
      },
    }

    URL_STRUCT = {
      type: Hash,
      elements: {
        url: { type: String },
      },
    }

    DICTIONARY_STRUCT = {
      "google_sheet" => GOOGLE_SHEET_STRUCT,
      "one_sky"      => ONE_SKY_STRUCT,
      "url"          => URL_STRUCT
    }
  end
end
