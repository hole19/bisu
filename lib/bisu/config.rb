module Bisu
  class Config
    def initialize(hash:)
      @hash = hash.deep_symbolize
      @hash.validate_structure!(EXPECTED_HASH)
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
          yield(t[:in], (t[:"out_#{downcase_locale}"] || t[:out]) % l, l[:language], l[:locale])
        end
      end
    end

    private

    EXPECTED_HASH = {
      type: Hash,
      elements: {
        type: { type: String },
        dictionary: { type: Hash, elements: {
          sheet_id: { type: String },
          keys_column: { type: String }
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
            language: { type: String }
          }
        } }
      }
    }
  end
end
